# encoding: utf-8

class Assessment < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  attr_accessor :group_activity, :homework_workload, :test_styles, :exams
  attr_accessible :content, :presentation_score, :grading_score, :difficulty_score, :title, :provider, :category, :group_activity, :homework_workload

  index_prefix 'sungshin'
  mapping do
    indexes :id, :type => 'string', :index => :not_analyzed
    indexes :title
    indexes :provider
    indexes :content
  end

  CATEGORIES = {
    elective_common: '공통교양',
    elective_core: '핵심교양',
    elective_general: '일반교양',
    required_core: '핵심전공',
    required_advanced: '전공심화'
  }

  SCORES = [
    ['F', 0, 0],
    ['D-', 1, 1.0],
    ['D0', 2, 1.3],
    ['D+', 3, 1.6],
    ['C-', 4, 2.0],
    ['C0', 5, 2.3],
    ['C+', 6, 2.6],
    ['B-', 7, 3.0],
    ['B0', 8, 3.3],
    ['B+', 9, 3.6],
    ['A-', 10, 4.0],
    ['A0', 11, 4.3],
    ['A+', 12, 4.5]
  ]

  GROUP_ACTIVITIES = {
    none: '없음',
    required: '있음'
  }

  TEST_STYLES = {
    test_style_short_answer: '주관식',
    test_style_multiple_answer: '객관식',
    test_style_write_out_answer: '서술형'
  }.each do |key, value|
    attr_accessor key
    attr_accessible key
  end

  HOMEWORK_WORKLOADS = {
    heavy: '많음',
    moderate: '중간',
    light: '적음'
  }

  EXAMS = {
    exam_midterm: '중간',
    exam_final: '기말'
  }.each do |key, value|
    attr_accessor key
    attr_accessible key
  end

  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true
  validates :provider, presence: true
  validates :presentation_score, presence: true, inclusion: { in: 0..12 }
  validates :difficulty_score, presence: true, inclusion: { in: 0..12 }
  validates :grading_score, presence: true, inclusion: { in: 0..12 }
  validates :group_activity, presence: true
  validates :homework_workload, presence: true

  default_scope { order 'id DESC' }

  after_initialize :deserialize_misc_items
  before_save :calculate_overall_score
  before_save :serialize_misc_items
  before_save :make_category_values

  has_many :votes
  has_many :comments

  def self.major
    where(is_major: true)
  end

  def self.non_major
    where(is_major: false)
  end

  def self.per_page
    20
  end

  def self.by(user)
    where(user_id: user.id)
  end

  def self.scores_conversion_hash
    return @scores_conversion_hash if @scores_conversion_hash

    @scores_conversion_hash = Hash.new

    SCORES.each do |score_tuple|
      @scores_conversion_hash[score_tuple[1]] = score_tuple[2]
    end

    @scores_conversion_hash
  end

  def self.scores_label_hash
    return @scores_label_hash if @scores_label_hash

    @scores_label_hash = Hash.new

    SCORES.each do |score_tuple|
      @scores_label_hash[score_tuple[1]] = score_tuple[0]
    end

    @scores_label_hash
  end

  def positive_votes_percentage
    return 0 if votes.empty?
    ((votes.positive.count.to_f) / (votes.count.to_f) * 100).to_i
  end

  def negative_votes_percentage
    return 0 if votes.empty?
    ((votes.negative.count.to_f) / (votes.count.to_f) * 100).to_i
  end

  def update_votes_count
    self.upvote_count = votes.positive.count
    self.downvote_count = votes.negative.count
    save
  end

  def update_comment_count
    self.comment_count = comments.count
    save
  end

  def update_hit_count
    self.hit_count += 1
    save
  end

  def packed_comments
    return @packed_comments if @packed_comments

    comments_hash = {}

    comments.order('id ASC').each do |comment|
      if comment.parent_id
        comments_hash[comment.parent_id].children << comment
      else
        comments_hash[comment.id] = comment
      end
    end

    @packed_comments = comments_hash.values.sort { |c1, c2| c1.id <=> c2.id }
  end

  private
    def calculate_overall_score
      c = self.class.scores_conversion_hash
      self.overall_score = (c[presentation_score] + c[difficulty_score] + c[grading_score]) / 3.0
    end

    def deserialize_misc_items
      return unless misc_items

      result_hash = ActiveSupport::JSON.decode misc_items

      self.group_activity = result_hash['group_activity'].to_sym
      self.homework_workload = result_hash['homework_workload'].to_sym
      self.test_styles = result_hash['test_styles'].map(&:to_sym).each { |test_style| self.send "#{test_style}=", '1' }
      self.exams = result_hash['exams'].map(&:to_sym).each { |exam| self.send "#{exam}=", '1' }
    end

    def serialize_misc_items
      result_hash = {
        group_activity: group_activity,
        test_styles: [],
        homework_workload: homework_workload,
        exams: []
      }

      TEST_STYLES.each do |key, label|
        value = self.send(key)
        if value && value.to_s == '1'
          result_hash[:test_styles] << key
        end
      end

      EXAMS.each do |key, label|
        value = self.send(key)
        if value && value.to_s == '1'
          result_hash[:exams] << key
        end
      end

      self.misc_items = result_hash.to_json
    end

    def make_category_values
      self.is_major = !!(self.category.to_s =~ /required/)
      true
    end
end

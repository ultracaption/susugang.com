class Vote < ActiveRecord::Base
  attr_accessible :positive

  belongs_to :assessment
  belongs_to :user

  validates :assessment_id, presence: true
  validates :user_id, uniqueness: { scope: :assessment_id }
  after_save :update_assessment_votes_count

  def self.positive
    where(positive: true)
  end

  def self.negative
    where(positive: false)
  end

  private
    def update_assessment_votes_count
      assessment.update_votes_count
    end
end

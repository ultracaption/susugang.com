class Comment < ActiveRecord::Base
  attr_accessible :content, :parent_id

  belongs_to :user
  belongs_to :assessment

  after_save :update_assessment_comment_count

  attr_accessor :children

  def children
    @children ||= []
  end

  private
    def update_assessment_comment_count
      assessment.update_comment_count
    end
end

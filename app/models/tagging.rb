class Tagging < ActiveRecord::Base
  attr_accessible :tag_id, :coord_x, :coord_y
  belongs_to :lecture
  belongs_to :user

  validates :tag_id, uniqueness: { scope: [:lecture_id, :user_id] }
end

class AddVotesCountToAssessments < ActiveRecord::Migration
  def change
    change_table :assessments do |t|
      t.integer :upvote_count, default: 0
      t.integer :downvote_count, default: 0
      t.integer :hit_count, default: 0
      t.integer :comment_count, default: 0
    end
  end
end

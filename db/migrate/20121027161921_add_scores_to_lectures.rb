class AddScoresToLectures < ActiveRecord::Migration
  def change
    change_table :lectures do |t|
      t.float :overall_score
      t.float :presentation_score
      t.float :difficulty_score
      t.float :grading_score
    end
  end
end

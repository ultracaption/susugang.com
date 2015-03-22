class AddAssessmentCountToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :assessment_count
    end
  end
end

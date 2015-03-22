class AddAdditionalFieldsToAssessments < ActiveRecord::Migration
  def change
    change_table :assessments do |t|
      t.string :title
      t.string :provider
      t.string :category
      t.boolean :is_major
      t.string :misc_items
    end
  end
end

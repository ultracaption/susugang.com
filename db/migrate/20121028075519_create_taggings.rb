class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer :tag_id
      t.integer :lecture_id
      t.integer :user_id

      t.integer :coord_x
      t.integer :coord_y

      t.timestamps
    end
  end
end

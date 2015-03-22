class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :assessment_id
      t.boolean :positive

      t.timestamps
    end
  end
end

class RemoveEmailFromUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :email
      t.string :student_id
    end
  end
end

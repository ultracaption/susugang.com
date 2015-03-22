class CreatePreRegistrations < ActiveRecord::Migration
  def change
    create_table :pre_registrations do |t|
      t.string :mobile_contact
      t.timestamps
    end
  end
end

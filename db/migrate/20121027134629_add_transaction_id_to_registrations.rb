class AddTransactionIdToRegistrations < ActiveRecord::Migration
  def change
    change_table :registrations do |t|
      t.integer :transaction_id
    end
  end
end

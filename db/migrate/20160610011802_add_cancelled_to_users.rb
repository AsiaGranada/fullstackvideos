class AddCancelledToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cancelled, :boolean, :default => false
  end
end

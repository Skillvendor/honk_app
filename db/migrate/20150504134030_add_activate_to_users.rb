class AddActivateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmation_code, :string
    add_column :users, :activated, :boolean
  end
end

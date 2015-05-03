class AddAdminToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :admin, :integer
  end
end

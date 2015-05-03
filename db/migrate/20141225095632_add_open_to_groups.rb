class AddOpenToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :open, :boolean, default: true
  end
end

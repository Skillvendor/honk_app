class AddOwnerToSuggested < ActiveRecord::Migration
  def change
    add_column :suggesteds, :owner, :integer
  end
end

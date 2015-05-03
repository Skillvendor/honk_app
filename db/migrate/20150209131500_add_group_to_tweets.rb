class AddGroupToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :group, :integer
  end
end

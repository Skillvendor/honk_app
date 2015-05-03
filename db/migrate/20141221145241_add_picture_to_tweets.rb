class AddPictureToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :picture, :string
  end
end

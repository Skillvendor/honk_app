class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps null: false
    end
    add_index :followers, :follower_id
    add_index :followers, :followed_id
    add_index :followers, [:follower_id, :followed_id], unique: true

  end
end

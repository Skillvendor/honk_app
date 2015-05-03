class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.text :content
      t.references :user, index: true

      t.timestamps null: false
    end
    add_index :tweets, [:user_id, :created_at]
  end
end

class CreateHashrelations < ActiveRecord::Migration
  def change
    create_table :hashrelations do |t|
      t.integer :tweet_id
      t.integer :hashtag_id

      t.timestamps null: false
    end
    add_index :hashrelations, [:tweet_id, :hashtag_id], unique: true
  end
end

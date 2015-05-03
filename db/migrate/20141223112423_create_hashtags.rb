class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :name

      t.timestamps null: false
    end
  end
  add_index :hashtags, :name, unique: true
end

class CreateGrouprels < ActiveRecord::Migration
  def change
    create_table :grouprels do |t|
      t.integer :user_id
      t.integer :group_id

      t.timestamps null: false
    end
    add_index :grouprels, [:user_id, :group_id], unique: true
  end
end

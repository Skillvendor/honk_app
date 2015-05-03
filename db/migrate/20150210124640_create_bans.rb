class CreateBans < ActiveRecord::Migration
  def change
    create_table :bans do |t|
      t.integer :group_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

class CreateSuggesteds < ActiveRecord::Migration
  def change
    create_table :suggesteds do |t|
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

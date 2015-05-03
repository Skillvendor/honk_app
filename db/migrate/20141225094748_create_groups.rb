class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.text :name
      t.text :description

      t.timestamps null: false
    end
    add_index :groups, :name, unique: true
  end
end

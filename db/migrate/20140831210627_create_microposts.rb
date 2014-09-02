# Listing 10.1: The Micropost migration.
class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    # Listing 10.1: Adding an index on user_id and created_at.
    add_index :microposts, [:user_id, :created_at]
  end
end

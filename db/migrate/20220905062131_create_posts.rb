class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.integer :genre_id
      t.integer :place_id, null: false
      t.string :title
      t.text :text, null: false

      t.timestamps
    end
  end
end

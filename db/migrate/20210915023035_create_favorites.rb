class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :post_id
      t.timestamps
    end
    add_foreign_key :favorites, :users
    add_foreign_key :favorites, :posts
  end
end

class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.references :user
      t.references :post
      t.timestamps
    end
    add_foreign_key :favorites, :users
    add_foreign_key :favorites, :posts
  end
end

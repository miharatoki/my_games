class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :user
      t.references :genre
      t.string :title
      t.text :body
      t.integer :total_score
      t.integer :story_score
      t.integer :story_score
      t.integer :operability_score
      t.integer :sound_socre
      t.integer :balance_socre
      t.timestamps
    end
    add_foreign_key :posts, :users
  end
end

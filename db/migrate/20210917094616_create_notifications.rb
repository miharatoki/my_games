class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :post_comment_id
      t.integer :favorite_id
      t.integer :sender_id
      t.integer :receiver_id
      t.string :type, null: false
      t.boolean :check, default: false, null: false 

      t.timestamps
    end
  end
end

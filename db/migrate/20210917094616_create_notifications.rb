class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :post_comment
      t.references :favorite
      t.references :sender, foreign_key: { to_table: :users }
      t.references :receiver, foreign_key: { to_table: :users }
      t.string :type, null: false
      t.boolean :check, default: false, null: false 

      t.timestamps
    end
  end
end

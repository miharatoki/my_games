class AddPostIdToNotification < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :post, foreign_key: true
  end
end

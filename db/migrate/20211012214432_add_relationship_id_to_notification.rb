class AddRelationshipIdToNotification < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :relationship, foreign_key: true
  end
end

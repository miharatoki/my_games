class RenameTypeColumnToNotifications < ActiveRecord::Migration[5.2]
  def change
    rename_column :notifications, :type, :action
  end
end

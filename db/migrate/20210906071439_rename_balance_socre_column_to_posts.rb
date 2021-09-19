class RenameBalanceSocreColumnToPosts < ActiveRecord::Migration[5.2]
  def change
    rename_column :posts, :balance_socre, :balance_score
  end
end

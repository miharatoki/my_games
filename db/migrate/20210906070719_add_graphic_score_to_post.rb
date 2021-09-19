class AddGraphicScoreToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :graphic_score, :integer
  end
end

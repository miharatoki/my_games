class RenameSoundSocreColumnToPosts < ActiveRecord::Migration[5.2]
  def change
    rename_column :posts, :sound_socre, :sound_score
  end
end

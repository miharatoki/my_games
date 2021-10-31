class Post < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  has_many   :post_comments, dependent: :destroy
  has_many   :favorites,     dependent: :destroy
  has_many   :notifications, dependent: :destroy

  validates :title,             presence: true, length: { maximum: 30 }
  validates :body,              presence: true, length: { maximum: 400 }
  validates :total_score,       presence: true
  validates :story_score,       presence: true
  validates :graphic_score,     presence: true
  validates :operability_score, presence: true
  validates :sound_score,       presence: true
  validates :balance_score,     presence: true

  def favorite_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.post_sort(sort)
    sort_word =
    if sort == '新着順'
      'created_at DESC'
    elsif sort == '投稿順'
      'created_at ASC'
    elsif sort == '総合評価'
      'total_score DESC'
    elsif sort == 'ストーリー'
      'story_score DESC'
    elsif sort == 'グラフィック'
      'graphic_score DESC'
    elsif sort == '主題歌・BGM'
      'sound_score DESC'
    elsif sort == '操作性'
      'operability_score DESC'
    elsif sort == 'ゲームバランス'
      'balance_score DESC'
    end
    Post.order(sort_word)
  end

end

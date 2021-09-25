class Post < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  has_many   :post_comments, dependent: :destroy
  has_many   :favorites,     dependent: :destroy

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

end

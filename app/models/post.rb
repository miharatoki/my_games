class Post < ApplicationRecord
  belongs_to :user
  belongs_to :genre

  validates :title,             presence: true
  validates :body,              presence: true
  validates :total_score,       presence: true, length: {minimum: 1, maximum: 5}
  validates :story_score,       presence: true, length: {minimum: 1, maximum: 5}
  validates :graphic_score,     presence: true, length: {minimum: 1, maximum: 5}
  validates :operability_score, presence: true, length: {minimum: 1, maximum: 5}
  validates :sound_socre,       presence: true, length: {minimum: 1, maximum: 5}
  validates :balance_score,     presence: true, length: {minimum: 1, maximum: 5}

end

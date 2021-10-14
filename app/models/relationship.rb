class Relationship < ApplicationRecord
  belongs_to :followed, class_name: 'User'
  belongs_to :follower, class_name: 'User'
  has_one :notification, dependent: :destroy

  validates :followed_id, presence: true
  validates :follower_id, presence: true
end

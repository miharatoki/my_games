class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts,         dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites,     dependent: :destroy
  has_many :send_notification,    class_name: 'Notification', foreign_key: :sender_id,  dependent: :destroy
  has_many :receive_notification, class_name: 'Notification', foreign_key: :recever_id, dependent: :destroy

  # 自分がフォローしている
  has_many :relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :followings, through: :relationships, source: :followed # 自分がフォローしているユーザーを取得

  # 自分がフォローされている
  has_many :reverse_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower #自分をフォローしているユーザーを取得

  validates :name, presence: true, length: { minimum: 2, maximum: 10 }, uniqueness: true
  validates :introduction, length: {maximum: 140 }

  attachment :profile_image

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(followed_user)
    relationships.find_by(followed_id: followed_user).destroy
  end

  def following?(user)
    followings.include?(user)
  end
end

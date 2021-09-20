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

  validates :name, presence: true, length: { minimum: 2, maximum: 10 }, uniqueness: true
  validates :introduction, length: {maximum: 140 }

  attachment :profile_image

end

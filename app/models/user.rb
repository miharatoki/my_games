class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts,         dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites,     dependent: :destroy
  has_many :send_notification,    class_name: 'Notification', foreign_key: :sender_id,
                                  dependent: :destroy
  has_many :receive_notification, class_name: 'Notification', foreign_key: :recever_id,
                                  dependent: :destroy

  # 自分がフォローしている
  has_many :relationships, class_name: 'Relationship', foreign_key: 'follower_id',
                           dependent: :destroy
  has_many :followings, through: :relationships, source: :followed # 自分がフォローしているユーザーを取得

  # 自分がフォローされている
  has_many :reverse_relationships, class_name: 'Relationship', foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower # 自分をフォローしているユーザーを取得

  validates :name, presence: true, length: { minimum: 2, maximum: 10 }
  validates :introduction, length: { maximum: 140 }

  attachment :profile_image

  def follow(user_id)
    relationship = relationships.create(followed_id: user_id)
    Notification.create(relationship_id: relationship.id, sender_id: relationship.follower_id,
                        receiver_id: relationship.followed_id, action: 'relationship')
  end

  def unfollow(followed_user)
    relationships.find_by(followed_id: followed_user).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def notication_create(post, sender)
    sender.followers.each do |follower|
      Notification.create(post_id: post.id, sender_id: sender.id,
                          receiver_id: follower.id, action: 'post')
    end
  end

  def self.user_post_sort(sort, user_id)
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
    Post.where(user_id: user_id).order(sort_word)
  end
end

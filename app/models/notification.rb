class Notification < ApplicationRecord
  belongs_to :post_comment, optional: true
  belongs_to :favorite,     optional: true
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id', optional: true
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id', optional: true

  def self.favorited_post(favorite_id)
    favorite = Favorite.find(favorite_id)
    favorite.post_id
  end

  def self.commented_post(post_comment_id)
    post_comment = PostComment.find(post_comment_id)
    post_comment.post_id
  end

end

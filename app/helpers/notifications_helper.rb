module NotificationsHelper
  def favorited_post(favorite_id)
    favorite = Favorite.find(favorite_id)
    favorite.post_id
  end

  def commented_post(post_comment_id)
    post_comment = PostComment.find(post_comment_id)
    post_comment.post_id
  end
end

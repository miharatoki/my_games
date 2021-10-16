class FavoritesController < ApplicationController
  before_action :set_post

  def create
    favorite = current_user.favorites.create(post_id: params[:post_id])
    Notification.create(favorite_id: favorite.id, sender_id: current_user.id,
                        receiver_id: @post.user_id, action: 'favorite')
  end

  def destroy
    Favorite.find_by(user_id: current_user, post_id: params[:post_id]).destroy
  end

  private

  # いいねボタンのif分岐に使用
  def set_post
    @post = Post.find(params[:post_id])
  end
end

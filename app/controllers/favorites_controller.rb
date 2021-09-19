class FavoritesController < ApplicationController
  before_action :ensure_sign_in
  before_action :set_post


  def create
    favorite = current_user.favorites.create(post_id: params[:post_id])
    Notification.create(favorite_id: favorite.id, sender_id: current_user.id, receiver_id: @post.user_id, action: 'favorite')
  end

  def destroy
    favorite = Favorite.find_by(user_id: current_user, post_id: params[:post_id])
    favorite.destroy
  end

  private

  def ensure_sign_in
    # ログインしていないとログイン画面へ遷移
    unless user_signed_in?
      redirect_to new_user_session_path, alert: 'ログイン、または新規登録をしてください'
    end
  end
  
  # いいねボタンのif分岐に使用
  def set_post
    @post = Post.find(params[:post_id])
  end
end

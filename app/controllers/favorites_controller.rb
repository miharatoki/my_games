class FavoritesController < ApplicationController
  before_action :ensure_sign_in
  before_action :set_post
  

  def create
    current_user.favorites.create(post_id: params[:post_id])
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
  
  def set_post
    @post = Post.find(params[:post_id])
  end
end

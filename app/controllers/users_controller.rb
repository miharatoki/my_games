class UsersController < ApplicationController
  before_action :ensure_sign_in
  before_action :set_user, only: [:show, :edit, :update]
  before_action :ensure_user, only: [:edit, :update]

  def show
    @posts = Post.where(user_id: params[:id]).order(params[:sort])
    @posts = @posts.page(params[:page]).per(6)
  end

  def edit

  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'アカウント情報を編集しました。'
      redirect_to user_path(current_user.id)
    else
      @user = User.find(params[:id])
      render :edit
    end
  end

  def genre_search
    # パラメーターのジャンルIDでPostモデルから検索
    searched_posts = Post.where(genre_id: (params[:genre]))
    @posts = searched_posts.page(params[:page]).per(6)
    @user = User.find(params[:user_id])
    render :show
  end

  def title_search
    # shomページの検索フォームの値でPostモデルから検索
    searched_posts = Post.where('title LIKE ?',"%#{params[:keyword]}%")
    @posts = searched_posts.page(params[:page]).per(6)
    @user = User.find(current_user.id)
    render :show
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_sign_in
    # ログインしていないとログイン画面へ遷移
    unless user_signed_in?
      flash[:alert] = 'ログイン、または新規登録をしてください'
      redirect_to new_user_session_path
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_user
    # 自分以外の編集ページを表示しようとすると投稿一覧へ遷移
    unless @user.id == current_user.id
      flash[:alert] = '自分以外のアカウント情報は編集できません'
      redirect_to posts_path
    end
  end

end

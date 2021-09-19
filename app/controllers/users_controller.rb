class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :ensure_user, only: [:edit, :update]

  def show
    if params[:sort].nil?
      # ソートしていなかったら、降順でレコードを取得
      @posts = Post.where(user_id: params[:id]).order('created_at DESC').page(params[:page]).per(6)
    else
      # ソートしていたら、ソート内容でレコードを所得
      @posts = Post.where(user_id: params[:id]).order(params[:sort]).page(params[:page]).per(6)
    end
  end

  # 新規登録画面でバリデーションエラーが起きた際、indeアクションのurlに自動的に遷移するため、ページは作成せずアクションのみ定義
  # その状態でページリロードをすると新規登録画面へ遷移
  def index
  end

  def edit
  end

  def update
    if @user.name == 'ゲストユーザー'
      redirect_to edit_user_path(@user.id), alert: 'ゲストユーザーはプロフィール編集ができません'
    else
      if @user.update(user_params)
        redirect_to user_path(current_user.id), notice: 'アカウント情報を編集しました。'
      else
        render :edit
      end
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

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_user
    # 自分以外の編集ページを表示しようとすると投稿一覧へ遷移
    unless @user.id == current_user.id
      redirect_to posts_path, alert: '自分以外のアカウント情報は編集できません'
    end
  end

end

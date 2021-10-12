class UsersController < ApplicationController
  before_action :set_user,    only: [:show, :edit, :update]
  before_action :ensure_user, only: [:edit, :update]

  def show
    if params[:sort].nil?
      # ソートしていなかったら、投稿日を降順でレコードを取得
      @posts = Post.where(user_id: params[:id]).order('created_at DESC').includes(:genre).page(params[:page]).per(6)
    else
      # ソートしていたら、ソート内容でレコードを所得
      @posts = Post.where(user_id: params[:id]).order(params[:sort]).includes(:genre).page(params[:page]).per(6)
    end
  end

  def index
    # 新規登録画面でバリデーションエラーが起きた際、indexアクションのurlに自動的に遷移するため、ページは作成せずアクションのみ定義
    # その状態でページリロードをすると新規登録画面へ遷移
  end

  def edit
  end

  def followers
    @user = User.find(params[:user_id])
  end

  def following
    @user = User.find(params[:user_id])
  end

  def update
    if @user.name == 'ゲストユーザー'
      # ゲストユーザーでログインしている時はupdateできない
      redirect_to edit_user_path(@user.id), alert: 'ゲストユーザーはプロフィール編集ができません'
    else
      if @user.update(user_params)
        redirect_to user_path(current_user.id), notice: 'アカウント情報を編集しました'
      else
        render :edit
      end
    end
  end

  def genre_search
    # 全て表示を選択した場合はshowアクションへリダイレクト
    if params[:genre] == '9'
      redirect_to user_path(params[:user_id])
    else
      # パラメーターのジャンルIDでPostモデルから検索
      @user = User.find(params[:user_id])
      @posts = Post.where(user_id: @user.id, genre_id: params[:genre]).includes(:user, :genre).page(params[:page]).per(6)
      render :show
    end
  end

  def title_search
    # shomページの検索フォームの値でPostモデルから検索
    @user = User.find(params[:user_id])
    searched_posts = Post.where('title LIKE ?',"%#{params[:keyword]}%")
    @posts = searched_posts.where(user_id: @user.id).includes(:user, :genre).page(params[:page]).per(6)
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
    # 自分以外のユーザーがの編集ページを表示、urlからupdateアクションを実行するとフラッシュメッセージ
    unless @user.id == current_user.id
      redirect_to posts_path, alert: '自分以外のアカウント情報は編集できません'
    end
  end

end

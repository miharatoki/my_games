class PostsController < ApplicationController
  before_action :ensure_sign_in
  before_action :set_post,  only: [:show, :edit, :update, :destroy]
  before_action :ensure_posted_user,  only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def index
    @posts = Post.order(params[:sort]).page(params[:page]).per(6)
  end

  def show
    @post_comment = PostComment.new
  end

  def edit
  end

  def create
    @post = current_user.posts.new(post_params)
      if @post.save
        flash[:notice] = '記録を作成しました'
        redirect_to post_path(@post.id)
      else
        render :new
      end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = '記録を更新しました'
      redirect_to post_path(@post.id)
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    flash[:notice] = '記録を削除しました'
    redirect_to user_path(current_user.id)
  end

  def genre_search
    # パラメーターのジャンルIDでPostモデルから検索
    searched_posts = Post.where(genre_id: (params[:genre]))
    @posts = searched_posts.page(params[:page]).per(6)
    # shared/searchの条件分岐の際、userのidが必要なため記述
    @user = User.find(current_user.id)
    render :index
  end

  def title_search
    # indexページの検索フォームの値でPostモデルから検索
    searched_posts = Post.where('title LIKE ?',"%#{params[:keyword]}%")
    @posts = searched_posts.page(params[:page]).per(6)
    # shared/searchの条件分岐の際、userのidが必要なため記述
    @user = User.find(current_user.id)
    render :index
  end

  private
  def post_params
    params.require(:post).permit(:genre_id, :title, :body, :total_score, :story_score, :graphic_score, :operability_score, :sound_score, :balance_score)
  end

  def ensure_sign_in
    # ログインしていないとログイン画面へ遷移
    unless user_signed_in?
      flash[:alert] = 'ログイン、または新規登録をしてください'
      redirect_to new_user_session_path
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_posted_user
    # urlから直接、自分以外の投稿を編集しようとすると投稿一覧へ遷移
    unless @post.user_id == current_user.id
      flash[:alert] = '自分以外の投稿は編集できません'
      redirect_to posts_path
    end
  end

end

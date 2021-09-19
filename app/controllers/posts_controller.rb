class PostsController < ApplicationController
  before_action :set_post,  only: [:show, :edit, :update, :destroy]
  before_action :ensure_posted_user,  only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def index
    if params[:sort].nil?
      # ソートしていなかったら、降順でレコードを取得
      @posts = Post.order('created_at DESC').page(params[:page]).per(6)
    else
      # ソートしていたら、ソート内容でレコードを所得
      @posts = Post.order(params[:sort]).page(params[:page]).per(6)
    end
  end

  def show
    @post_comment = PostComment.new
  end

  def edit
  end

  def create
    @post = current_user.posts.new(post_params)
      if @post.save
        redirect_to post_path(@post.id), notice: '記録を作成しました'
      else
        render :new
      end
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post.id), notice: '記録を更新しました'
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to user_path(current_user.id), notice: '記録を削除しました'
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

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_posted_user
    # urlから直接、自分以外の投稿を編集しようとすると投稿一覧へ遷移
    unless @post.user_id == current_user.id
      redirect_to posts_path, alert: '自分以外の投稿は編集できません'
    end
  end

end

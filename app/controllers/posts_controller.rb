class PostsController < ApplicationController
  before_action :set_genre_array,     only: [:new, :create, :edit, :update]
  before_action :ensure_posted_user,  only: [:edit, :update, :destroy]
  before_action :ensure_sign_in

  def new
    @post = Post.new
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
  end

  def create
    @post = current_user.posts.new(post_params)
      if @post.save
        flash[:notice] = '記録を作成しました。'
        redirect_to post_path(@post.id)
      else
        render :new
      end
  end

  def update
  end

  def destroy

  end

  private
  def post_params
    params.require(:post).permit(:genre_id, :title, :body, :total_score, :story_score, :graphic_score, :operability_score, :sound_score, :balance_score)
  end

  def ensure_sign_in
    unless user_signed_in?
      flash[:alert] = 'ログイン、または新規登録をしてください。'
      redirect_to new_user_session_path
    end
  end

  def ensure_posted_user
    @post = Post.find(params[:id])
    unless @post.user_id = current_user.id
      flash[:alert] = '権限がないため処理できません。'
      redirect_to :posts_path
    end
  end

  def set_genre_array
    @genre_array = Genre.select_array
  end

end

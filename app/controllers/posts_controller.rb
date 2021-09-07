class PostsController < ApplicationController
  before_action :set_genre_array, only: [:new, :create, :edit, :update]

  def new
    @post = Post.new
  end

  def index
    @posts = Post.all
  end

  def show
  end

  def edit
  end

  def create
    @post = current_user.posts.new(post_params)
      if @post.save
        flash[:notice] = '記録を作成しました。'
        redirect_to posts_path
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

  def genre_params
    params.require(:post).permit(:genre)
  end

  def set_genre_array
    @genre_array = Genre.select_array
  end

end

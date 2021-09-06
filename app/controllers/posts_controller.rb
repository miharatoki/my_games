class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def index
  end

  def show
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    
    if @post.save!
      flash[:notice] = '記録を作成しました。'
      redirect_to posts_path
    else
      @post = Post.new
      render :new
    end
  end

  def update
  end

  def destroy
  end

  private
  def post_params
    params.require(:post).permit(:genre_id, :title, :body, :total_score, :story_score, :graphic_score, :operability_score, :sound_socre, :balance_socre)
  end

end

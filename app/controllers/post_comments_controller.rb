class PostCommentsController < ApplicationController
  before_action :ensure_sign_in

  def create
    @post_comment = PostComment.new(post_comment_params)
    @post_comment.post_id = params[:post_id]
    @post_comment.user_id = current_user.id
    if @post_comment.save
      flash[:notice] = '投稿しました'
      @post = Post.find(params[:post_id])
      render :comment_field
    else
      @post = Post.find(params[:post_id])
      @post_comment = @post_comment
      render :error
    end
  end

  def destroy

    render :index
  end

  private
  def post_comment_params
    params.require(:post_comment,).permit(:post_id, :comment)
  end

  def ensure_sign_in
    unless user_signed_in?
      flash[:alert] = 'ログイン、または新規登録をしてください。'
      redirect_to new_user_session_path
    end
  end

end

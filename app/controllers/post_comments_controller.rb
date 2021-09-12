class PostCommentsController < ApplicationController
  before_action :ensure_sign_in

  def create
    @post_comment = PostComment.new(post_comment_params)
    @post_comment.post_id = params[:post_id]
    @post_comment.user_id = current_user.id
    if @post_comment.save
      flash[:notice] = '投稿しました'
      redirect_to post_path(params[:post_id])
    else
      @post = Post.find(params[:post_id])
      @post_comment = @post_comment
      render 'posts/show'
    end
  end

  def destroy

    @post_comment = Post.all
    # @post_comment.destroy
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

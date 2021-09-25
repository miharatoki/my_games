class PostCommentsController < ApplicationController

  def create
    @post_comment = PostComment.new(post_comment_params)
    @post_comment.post_id = params[:post_id]
    @post_comment.user_id = current_user.id
    if @post_comment.save
      @post = Post.find(params[:post_id])
      Notification.create(post_comment_id: @post_comment.id, sender_id: current_user.id, receiver_id: @post.user_id, action: 'post_comment')
      render :comment_field
    else
      @post = Post.find(params[:post_id])
      @post_comment = @post_comment
      render :error
    end
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end

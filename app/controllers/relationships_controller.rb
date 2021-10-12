class RelationshipsController < ApplicationController
  before_action :set_user

  def show_follow
    current_user.follow(@user.id)
    render :relationships_btn
  end

  def show_unfollow
    current_user.unfollow(@user.id)
    render :relationships_btn
  end
  
  def follow
    current_user.follow(@user)
    redirect_to request.referer
  end
  
  def unfollow
    current_user.unfollow(@user)
    redirect_to request.referer
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end
end

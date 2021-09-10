class UsersController < ApplicationController
  before_action :ensure_user, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit]
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image_id)
  end
  
  def ensure_user
    redirect_to request.referer unless params[:id] = current_user.id
  end
  
  def set_user
    @user = User.find(params[:id])
  end
    
end

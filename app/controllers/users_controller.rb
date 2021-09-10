class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit]
  before_action :ensure_user, only: [:show, :edit, :update]
  
  def index
  end

  def show
    
  end

  def edit
  end
  
  def update
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image_id)
  end
  
  def set_user
    @user = User.find(current_user.id)
  end
  
  def ensure_user
    redirect_to request.referer unless params[:id] = current_user.id
  end
    
end

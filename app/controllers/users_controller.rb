class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :ensure_user, only: [:edit, :update]
  before_action :ensure_sign_in

  def index
    @users = User.all
  end

  def show
    @posts = Post.where(user_id: params[:id])
    @posts = @posts.page(params[:page])
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'アカウント情報を編集しました。'
      redirect_to user_path(current_user.id)
    else
      @user = User.find(params[:id])
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image_id)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_user
    redirect_to request.referer unless @user.id = current_user.id
  end

  def ensure_sign_in
    unless user_signed_in?
      flash[:alert] = 'ログイン、または新規登録をしてください。'
      redirect_to new_user_session_path
    end
  end

end

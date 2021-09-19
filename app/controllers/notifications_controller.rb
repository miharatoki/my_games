class NotificationsController < ApplicationController
  before_action :ensure_user

  def index
    @notifications = Notification.where(receiver_id: params[:user_id], check: false)
  end

  def destroy_all
    notifications =Notification.where(receiver_id: params[:user_id], check: false)
    notifications.update(check: true)
    redirect_to user_notifications_path(params[:user_id])
  end

  private
  def ensure_user
    unless current_user.id == params[:user_id].to_i
      redirect_to posts_path, alert: '自分宛以外の通知を見ることはできません'
    end
  end
end

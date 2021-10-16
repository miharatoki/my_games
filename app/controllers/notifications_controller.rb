class NotificationsController < ApplicationController
  before_action :ensure_user

  def index
    @notifications = Notification.where(receiver_id: params[:user_id],
                                        check: false).includes(:sender).page(params[:page]).per(10)
  end

  def destroy
    Notification.where(receiver_id: params[:user_id], check: false).update(check: true)
    redirect_to user_notifications_path
  end

  def destroy_all
    Notification.where(receiver_id: params[:user_id], check: false).update(check: true)
    redirect_to user_notifications_path
  end

  private

  def ensure_user
    # urlで他ユーザー宛の通知を閲覧、操作しようとすると自ユーザー詳細ページへリダイレクト
    unless current_user.id == params[:user_id].to_i
      redirect_to user_path(current_user.id), alert: '自分宛以外の通知の閲覧、編集はできません'
    end
  end
end

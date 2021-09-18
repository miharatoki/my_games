class HomesController < ApplicationController
  before_action :ensure_sign_in

  def top
  end

  def guest_sign_in
    user = User.find_or_create_by(name: 'ゲストユーザー', email: 'guest@example.com') do |user|
      user.password = 'guestuser'
    end
    sign_in user
    redirect_to posts_path, notice: 'ゲストユーザーとしてログインしました'
  end

  private
  # ヘッダーのロゴをクリックした際、ログインしていたら投稿一覧ページへ遷移させるため
  def ensure_sign_in
    if user_signed_in?
      redirect_to posts_path
    end
  end
end

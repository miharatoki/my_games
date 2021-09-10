class HomesController < ApplicationController
  before_action :ensure_sign_in

  def top

  end

  private
  def ensure_sign_in
    if user_signed_in?
      redirect_to posts_path
    end
  end
end

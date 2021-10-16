module FeaturesHelper
  def log_in(email)
    visit new_user_session_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: 'password'
    click_button 'ログイン'
  end

  def guest_log_in
    visit root_path
    click_link 'ゲストログイン'
  end
end

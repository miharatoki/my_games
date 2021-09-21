require 'rails_helper'

feature 'トップページから新規登録、ログイン、ゲストログイン' do
  before do
    create(:user, email: 'test@test.com')
    visit root_path
  end

  feature '新規登録' do
    before do
      click_link '新規登録'
    end
    
    scenario '新規登録画面へ遷移できるか' do
      expect(current_path).to eq new_user_registration_path
    end
    
    scenario '新規登録した時にヘッダーとフラッシュメッセージが表示されているか' do
      fill_in 'user_name', with: 'テストユーザー'
      fill_in 'user_email', with: 'test@example.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button 'アカウント登録'
      expect(page).to have_content 'ようこそ、My Gamesへ！！'
      expect(page).to have_content 'ようこそ、テストユーザーさん！'
      expect(page).to have_content 'マイページ'
      expect(page).to have_content '通知'
      expect(page).to have_content '自分の記録'
      expect(page).to have_content 'みんなの記録'
      expect(page).to have_content '新しく記録する'
      expect(page).to have_content 'ログアウト'
      expect(current_path).to eq posts_path
    end
  end
  
  feature 'ログイン' do
    before do
      click_link 'アカウントをお持ちの方'
    end
    
    scenario 'ログインページに遷移できるか' do
      expect(current_path).to eq new_user_session_path
    end
    
    scenario 'ログイン時にフラッシューメッセージとヘッダーが表示されているか' do
      fill_in 'user_email', with: 'test@test.com'
      fill_in 'user_password', with: 'password'
      click_button 'ログイン'
      expect(page).to have_content 'ログインしました'
      expect(page).to have_content 'マイページ'
      expect(page).to have_content '通知'
      expect(page).to have_content '自分の記録'
      expect(page).to have_content 'みんなの記録'
      expect(page).to have_content '新しく記録する'
      expect(page).to have_content 'ログアウト'
      expect(current_path).to eq posts_path
    end
  end
  
  feature 'ゲストログイン' do
    scenario 'トップのゲストログインボタンを押下' do
      click_link 'ゲストログイン'
      expect(page).to have_content 'ゲストユーザーとしてログインしました'
      expect(page).to have_content 'マイページ'
      expect(page).to have_content '通知'
      expect(page).to have_content '自分の記録'
      expect(page).to have_content 'みんなの記録'
      expect(page).to have_content '新しく記録する'
      expect(page).to have_content 'ログアウト'
      expect(current_path).to eq posts_path
    end
  end
end

feature 'ゲストログイン' do
  before do
    guest_log_in
  end
  
  feature 'アカウント情報の編集' do
    before do
      click_link 'マイページ'
    end
    scenario 'ゲストユーザーは編集ができなくなっているか' do
      expect(page).to have_content '※ゲストユーザーは編集ができません'
      click_button '変更する'
      expect(page).to have_content 'ゲストユーザーはプロフィール編集ができません'
    end
  end
end

feature 'アカウント情報の編集' do
  before do
    user = create(:user, email: 'test@test.com')
    log_in(user.email)
    click_link 'マイページ'
  end
  
  scenario '編集内容が保存されるか' do
    expect(current_path).to eq edit_user_path(1)
    fill_in 'user_name', with: 'user'
    fill_in 'user_introduction', with: 'introduction'
    attach_file 'user_profile_image', "#{Rails.root}/app/assets/images/tatami02.jpeg"
    click_button '変更する'
    
    expect(current_path).to eq user_path(1)
    expect(page).to have_content 'アカウント情報を編集しました'
    user = User.order(:id).last
    expect(user.name).to eq 'user'
    expect(user.introduction).to eq 'introduction'
    # expect(user.profile_image_id).to eq 'tatami02.jpeg'
  end
  
  feature '無効な値ははバリデーションエラーになるか' do
    scenario '制限以下の文字数' do
      fill_in 'user_name', with: Faker::Lorem.characters(number: 1)
      click_button '変更する'
      expect(page).to have_content '2文字以上'
    end
    
    scenario '制限以上の文字数' do
      fill_in 'user_name', with: Faker::Lorem.characters(number: 11)
      fill_in 'user_introduction', with: Faker::Lorem.characters(number: 141)
      click_button '変更する'
      expect(page).to have_content '10文字以内'
      expect(page).to have_content '140文字以内'
    end
  end
end

feature 'ユーザー詳細ページ' do
  before do
    user = create(:user, email: 'test@test.com')
    create(:post, user_id: user.id)
    other_user = create(:user, name: 'other', email: 'other@other.com', password: 'other_user', password_confirmation: 'other_user')
    create(:post, user_id: other_user.id)
    # 133行目のユーザーとしてログイン
    log_in(user.email)
    visit user_path(user.id)
  end
  
  scenario 'ユーザーの投稿のみ表示されているか' do
    user = User.order(:id).first
    other_user = User.order(:id).last
    expect(current_path).to eq user_path(user.id)
    expect(page).to have_content "#{user.name}"
    expect(page).not_to have_content "#{other_user.name}"
    
    # 投稿一覧ページなら、両方のユーザーの投稿が表示される
    visit posts_path
    expect(page).to have_content "#{other_user.name}"
    expect(page).to have_content "#{user.name}"
  end
  
  
end
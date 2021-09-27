require 'rails_helper'

feature 'ユーザー情報編集ページ' do
  let!(:user) { create(:user) }

  before do
    log_in(user.email)
    click_link 'マイページ'
  end

  scenario '編集内容が保存されるか' do
    expect(current_path).to eq edit_user_path(user.id)
    fill_in 'user_name', with: 'user'
    fill_in 'user_introduction', with: 'introduction'
    attach_file 'user_profile_image', "#{Rails.root}/app/assets/images/tatami02.jpeg"
    click_button '変更する'

    expect(current_path).to eq user_path(user.id)
    expect(page).to have_content 'アカウント情報を編集しました'
    user = User.order(:id).last
    expect(user.name).to eq 'user'
    expect(user.introduction).to eq 'introduction'
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

  feature 'ヘッダーのリンク' do
    scenario 'マイページをクリックするとユーザー編集ページへ遷移する' do
      click_link 'マイページ'
      expect(current_path).to eq edit_user_path(user.id)
    end

    scenario '通知をクリックすると通知一覧ページへ遷移する' do
      click_link '通知'
      expect(current_path).to eq user_notifications_path(user.id)
    end

    scenario '自分の記録をクリックするとユーザー詳細ページへ遷移する' do
      click_link '自分の記録'
      expect(current_path).to eq user_path(user.id)
    end

    scenario 'みんなの記録をクリックすると投稿一覧ページへ遷移する' do
      click_link 'みんなの記録'
      expect(current_path).to eq posts_path
    end

    scenario '新しく記録するをクリックすると新規投稿ページへ遷移する' do
      click_link '新しく記録する'
      expect(current_path).to eq new_post_path
    end

    scenario 'ログアウトをクリックするとログアウトする' do
      click_link 'ログアウト'
      expect(current_path).to eq root_path
    end
  end
end

feature 'ゲストユーザーの場合' do
  before do
    guest_log_in
    click_link 'マイページ'
  end

  scenario '保存ボタンを押してもエラーメッセージ時が表示され保存できないか' do
    expect(page).to have_content '※ゲストユーザーは編集ができません'
    click_button '変更する'
    expect(page).to have_content 'ゲストユーザーはプロフィール編集ができません'
  end
end

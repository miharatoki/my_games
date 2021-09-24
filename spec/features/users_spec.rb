require 'rails_helper'

feature 'ログイン前' do

  feature 'アクセス制限' do
    before do
      @user = create(:user)
      genre = create(:genre)
      @post = create(:post, user_id: @user.id, genre_id: genre.id)
      visit root_path
    end
    
    scenario '投稿一覧ページや新規投稿ページなどにアクセスできないこと' do
      visit new_post_path
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(current_path).to eq new_user_session_path
      
      visit posts_path
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(current_path).to eq new_user_session_path
      
      visit post_path(@post.id)
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(current_path).to eq new_user_session_path
      
      visit edit_user_path(@post.id)
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(current_path).to eq new_user_session_path
      
      visit user_path(@user.id)
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(current_path).to eq new_user_session_path
      
      visit edit_user_path(@user.id)
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(current_path).to eq new_user_session_path
    end
  end
  
  feature '新規登録ページ' do
    before do
      visit new_user_registration_path
    end
    
    scenario 'ヘッダーのログインをクリックするとログインページへ遷移する' do
      click_link 'ログイン'
      expect(current_path).to eq new_user_session_path
    end
    
    scenario 'ヘッダーのロゴをクリックするとトップページへ遷移する' do
      click_link 'My Games'
      expect(current_path).to eq root_path
    end
  end
  
  feature 'ログインページ' do
    before do
      visit new_user_session_path
    end
    
    scenario 'ヘッダーの新規登録をクリックすると新規登録ページへ遷移する' do
      click_link '新規登録'
      expect(current_path).to eq new_user_registration_path
    end
    
    scenario 'ヘッダーのロゴをクリックするとトップページへ遷移する' do
      click_link 'My Games'
      expect(current_path).to eq root_path
    end
  end
end

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
    @user = create(:user, email: 'test@test.com')
    log_in(@user.email)
    click_link 'マイページ'
  end
  
  scenario '無効なurlをリクエストした場合404エラーが発生するか' do
      visit "/users/#{@user.id}/edit/error"
      expect(page).to have_content '404'
      
      visit "/users/#{@user.id}/editerror"
      expect(page).to have_content '404'
    end
  
  scenario '未発行のIDをリクエストした場合、404エラーページが表示されるか' do
      visit "/users/#{@user.id+100}/edit"
      expect(page).to have_content '404'
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
      expect(current_path).to eq edit_user_path(@user.id)
    end
    
    scenario '通知をクリックすると通知一覧ページへ遷移する' do
      click_link '通知'
      expect(current_path).to eq user_notifications_path(@user.id)
    end
    
    scenario '自分の記録をクリックするとユーザー詳細ページへ遷移する' do
      click_link '自分の記録'
      expect(current_path).to eq user_path(@user.id)
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

feature 'ユーザー詳細ページ' do
  before do
    @user = create(:user, email: 'test@test.com')
    create(:post, user_id: @user.id)
    other_user = create(:user, name: 'other', email: 'other@other.com', password: 'other_user', password_confirmation: 'other_user')
    create(:post, user_id: other_user.id)
    # 133行目のユーザーとしてログイン
    log_in(@user.email)
    visit user_path(@user.id)
  end
  
  feature 'ヘッダーのリンク' do
    scenario 'マイページをクリックするとユーザー編集ページへ遷移する' do
      click_link 'マイページ'
      expect(current_path).to eq edit_user_path(@user.id)
    end
    
    scenario '通知をクリックすると通知一覧ページへ遷移する' do
      click_link '通知'
      expect(current_path).to eq user_notifications_path(@user.id)
    end
    
    scenario '自分の記録をクリックするとユーザー詳細ページへ遷移する' do
      click_link '自分の記録'
      expect(current_path).to eq user_path(@user.id)
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
  
  scenario '並び替えができるか', js: true do
    user = create(:user)
    genre = create(:genre)
    high_score_post = create(:post, user_id: user.id, genre_id: genre.id, total_score: 5)
    row_score_post = create(:post, user_id: user.id, genre_id: genre.id, total_score: 1)
    
    visit user_path(user.id)
    expect(current_path).to eq user_path(user.id)
    posts = all('.posts-list')
    # デフォルトで新着順に並ぶので、後に作ったrow_score_postが先に配列に入る
    expect(posts[0].find('.text-truncate').text).to eq "#{row_score_post.title}"
    expect(posts[1].find('.text-truncate').text).to eq "#{high_score_post.title}"
    
    select '総合評価', from: 'sort'
    posts = all('.posts-list')
    # 総合評価の高いhigh_score_postが先に配列に入る
    expect(posts[0].find('.text-truncate').text).to eq "#{high_score_post.title}"
    expect(posts[1].find('.text-truncate').text).to eq "#{row_score_post.title}"
  end
  
  scenario 'ジャンル検索ができるか', js: true do
    user = create(:user)
    action = create(:genre, name: 'アクション')
    shooting = create(:genre, name: 'シューティング')
    action_post = create(:post, user_id: user.id, genre_id: action.id)
    shooting_post = create(:post, user_id: user.id, genre_id: shooting.id)
    
    visit user_path(user.id)
    expect(current_path).to eq user_path(user.id)
    # 両方とも表示されている
    expect(page).to have_content "#{shooting_post.title}"
    expect(page).to have_content "#{action_post.title}"
    
    select 'シューティング', from: 'select'
    # 検索したジャンル名「シューティング」のレコードのみ表示されている
    expect(page).to have_content "#{shooting_post.title}"
    expect(page).not_to have_content "#{action_post.title}"
  end
  
  scenario '作品名で検索ができる' do
    user = create(:user)
    test1_post = create(:post, user_id: user.id)
    test2_post = create(:post, user_id: user.id)
    
    visit user_path(user.id)
    expect(current_path).to eq user_path(user.id)
    # 両方とも表示されている
    expect(page).to have_content "#{test1_post.title}"
    expect(page).to have_content "#{test2_post.title}"
    
    fill_in 'keyword', with: "#{test1_post.title}"
    click_button '検索'
    # 検索したtest1_postの投稿のみ表示されている
    expect(page).to have_content "#{test1_post.title}"
    expect(page).not_to have_content "#{test2_post.title}"
  end
end
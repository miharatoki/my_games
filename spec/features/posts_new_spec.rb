require 'rails_helper'

feature '新規投稿ページ' do
  before do
    create(:genre)
    @user = create(:user, email: 'test@test.com')
    log_in(@user.email)
    visit new_post_path
  end

  scenario '有効な内容なら保存でき、投稿一覧とユーザー詳細ページに表示されているか', js: true do
    expect(current_path).to eq new_post_path
    fill_in 'post_title', with: 'test_post'
    select 'アクション', from: 'post_genre_id'
    fill_in 'post_body', with: 'test_body'
    find('#total-score').find("img[alt='5']").click
    find('#story-score').find("img[alt='4']").click
    find('#graphic-score').find("img[alt='3']").click
    find('#sound-score').find("img[alt='2']").click
    find('#operability-score').find("img[alt='1']").click
    find('#balance-score').find("img[alt='5']").click
    click_button '記録する'
    post = Post.order(:id).last
    expect(current_path).to eq post_path(post.id)
    expect(page).to have_content '記録を作成しました'
    expect(page).to have_content 'test_post'

    visit posts_path
    expect(page).to have_content 'test_post'
    visit user_path(@user.id)
    expect(page).to have_content 'test_post'
  end

  feature 'バリデーションエラーが発生するか', js: true do
    scenario '空白で保存しようとした時' do
      click_button '記録する'
      expect(page).to have_content 'ゲームタイトルが入力されていません'
      expect(page).to have_content '感想が入力されていません'
      expect(page).to have_content 'ジャンルを入力してください'
      expect(page).to have_content '総合評価が入力されていません'
      expect(page).to have_content 'ストーリーが入力されていません'
      expect(page).to have_content 'グラフィックが入力されていません'
      expect(page).to have_content '主題歌・BGMが入力されていません'
      expect(page).to have_content '操作性が入力されていません'
      expect(page).to have_content 'ゲームバランスが入力されていません'
    end

    scenario 'タイトルを30文字以上、感想を400文字以上で入力した時にバリデーションエラーが発生するか', js: true do
      fill_in 'post_title', with: Faker::Lorem.characters(number: 31)
      fill_in 'post_body', with: Faker::Lorem.characters(number: 401)
      select 'アクション', from: 'post_genre_id'
      find('#total-score').find("img[alt='5']").click
      find('#story-score').find("img[alt='4']").click
      find('#graphic-score').find("img[alt='3']").click
      find('#sound-score').find("img[alt='2']").click
      find('#operability-score').find("img[alt='1']").click
      find('#balance-score').find("img[alt='5']").click
      click_button '記録する'
      expect(page).to have_content 'ゲームタイトルは30文字以内で入力してください'
      expect(page).to have_content '感想は400文字以内で入力してください'
    end

    scenario 'タイトルを30文字ちょうど、感想を400文字ちょうどなら保存できるか', js: true do
      title = Faker::Lorem.characters(number: 30)
      body =  Faker::Lorem.characters(number: 400)
      fill_in 'post_title', with: title
      select 'アクション', from: 'post_genre_id'
      fill_in 'post_body', with: body
      find('#total-score').find("img[alt='5']").click
      find('#story-score').find("img[alt='4']").click
      find('#graphic-score').find("img[alt='3']").click
      find('#sound-score').find("img[alt='2']").click
      find('#operability-score').find("img[alt='1']").click
      find('#balance-score').find("img[alt='5']").click
      click_button '記録する'
      expect(page).to have_content '記録を作成しました'
      expect(page).to have_content title
      expect(page).to have_content body
    end
  end

  feature 'ヘッダーのリンク' do
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
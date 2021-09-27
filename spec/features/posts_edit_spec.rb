require 'rails_helper'

feature '投稿編集ページ' do
  let!(:user) { create(:user) }
  let!(:genre) { create(:genre) }
  let!(:post) { create(:post, user_id: user.id, genre_id: genre.id) }
  let(:genre) { create(:genre, name: 'シューティング') }

  before do
    log_in(user.email)
    visit edit_post_path(post.id)
  end


  scenario '投稿内容の編集ができるか', js: true do
    expect(current_path).to eq edit_post_path(post.id)
    fill_in 'post_title', with: 'edit_title'
    fill_in 'post_body', with: 'edit_body'
    select 'シューティング', from: 'post_genre_id'
    find("#total-score-#{post.id}").find("img[alt='1']").click
    find("#story-score-#{post.id}").find("img[alt='1']").click
    find("#graphic-score-#{post.id}").find("img[alt='1']").click
    find("#sound-score-#{post.id}").find("img[alt='1']").click
    find("#operability-score-#{post.id}").find("img[alt='1']").click
    find("#balance-score-#{post.id}").find("img[alt='1']").click
    click_button '記録する'
    expect(current_path).to eq post_path(post.id)
    expect(page).to have_content '記録を更新しました'
    expect(page).to have_content 'edit_title'
    visit edit_post_path(post.id)
    expect(find('#post_title')['value']).to eq 'edit_title'
  end

  scenario '変更内容を削除ボタンを押すと書き換えた箇所が削除されるか', js: true do
    fill_in 'post_title', with: 'edit_title'
    expect(find('#post_title')['value']).to eq "edit_title"
    click_button '変更内容を削除'
    expect(find('#post_title')['value']).to eq "#{post.title}"
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

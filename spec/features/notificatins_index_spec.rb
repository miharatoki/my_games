require 'rails_helper'

feature '通知一覧ページ' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:genre) { create(:genre) }
  let!(:post) { create(:post, user_id: user.id, genre_id: genre.id) }

  before do
    log_in(user.email)
    visit post_path(post.id)
  end

  feature 'コメントへの通知' do
    before do
      fill_in 'post_comment_comment', with: 'test_comment'
      click_button '送信'
      wait_for_ajax(5) do
        visit user_notifications_path(user.id)
      end
    end

    scenario 'コメントしたユーザー名をクリックするとユーザー詳細ページに遷移するか', js: true do
      click_link "#{user.name}"
      expect(current_path).to eq user_path(user.id)
    end

    scenario '「あなたの投稿」をクリックするとコメントされた投稿の詳細ページに遷移するか', js: true do
      click_link 'あなたの投稿'
      expect(current_path).to eq post_path(post.id)
     end

     scenario '通知を削除できるか', js: true do
      click_link '削除'
      expect(page).to have_content '通知はありません'
    end
  end

  feature 'いいねへの通知' do
    before do
      click_link '💙'
      wait_for_ajax do
        visit user_notifications_path(user.id)
      end
    end

    scenario 'いいねしたユーザー名をクリックするとユーザー詳細ページに遷移するか', js: true do
      click_link "#{user.name}"
      expect(current_path).to eq user_path(user.id)
    end

    scenario '「あなたの投稿」をクリックするといいねされた投稿の詳細ページに遷移するか', js: true do
      click_link 'あなたの投稿'
      expect(current_path).to eq post_path(post.id)
    end

    scenario '通知を削除できるか', js: true do
      click_link '削除'
      expect(page).to have_content '通知はありません'
    end
  end

  feature 'フォローの通知' do
    before do
      visit user_path(other_user.id)
      click_link 'フォローする'
      find('.navbar-toggler-icon').click
      click_link 'ログアウト'
      log_in(other_user.email)
      visit user_notifications_path(other_user.id)
    end

    scenario 'フォローしたユーザー名をクリックするとそのユーザーの詳細ページに遷移するか', js: true do
      click_link "#{user.name}"
      expect(current_path).to eq user_path(user.id)
    end

    scenario '削除をクリックするとその通知を削除できるか', js: true do
      click_link '削除'
      expect(page).to have_content '通知はありません'
    end
  end

  feature '通知の全削除', js: true do
    scenario '全て削除をクリックすると通知が全て削除されるか' do
      fill_in 'post_comment_comment', with: 'test_comment'
      click_button '送信'
      click_link '💙'
      wait_for_ajax do
        visit user_notifications_path(user.id)
      end
      expect(page).to have_content 'コメントしました'
      expect(page).to have_content 'いいね'
      click_link '全て削除'
      expect(page).to have_content '通知はありません'
    end
  end

  feature 'ヘッダーのリンク' do
    before do
      visit user_notifications_path(user.id)
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
require 'rails_helper'

feature '投稿詳細ページ' do
  let!(:user) { create(:user) }
  let!(:genre) { create(:genre) }
  let!(:post) { create(:post, user_id: user.id, genre_id: genre.id) }
  let!(:post_comment) { create(:post_comment, user_id: user.id, post_id: post.id, comment: 'test') }
  let(:another_user) { create(:user) }
  let(:another_post) { create(:post, user_id: another_user.id, genre_id: genre.id) }

  before do
    log_in(user.email)
    visit post_path(post.id)
    expect(current_path).to eq post_path(post.id)
  end

  scenario '自分の投稿の場合は編集ボタンと削除ボタンが表示されていること' do
    edit = find('.btn-info')
    destroy = find('.btn-danger')
    expect(edit[:href]).to eq edit_post_path(post.id)
    expect(destroy[:href]).to eq post_path(post.id)

  end

  scenario '自分以外の投稿の場合は編集ボタンと削除ボタンが表示されていないこと' do
    visit post_path(another_post.id)
    expect(current_path).to eq post_path(another_post.id)
    expect(all('.btn-info').empty?).to eq true
    expect(all('.btn-danger').empty?).to eq true
  end

  scenario '編集ボタンを押すと投稿編集ページに遷移すること' do
    find('.btn-info').click
    expect(current_path).to eq edit_post_path(post.id)
  end

  scenario '削除ボタンを押すとダイアログが表示されること' do
    find('.btn-danger').click
    expect {
      expect(page).to have_content 'キャンセル'
      expect(page).to have_content 'OK'
    }
  end

  scenario '削除ボタンのokを押すと投稿が削除されること' do
    find('.btn-danger').click
    expect {
      page.accept_confirm("本当に削除しますか？")
      expect(page).to have_content '記録を削除しました'
       post = Post.find_by(id: post.id)
      expect(post).to eq nil
    }
  end

  scenario '自分以外の投稿の場合は投稿者名が表示されていて、押下するとユーザ詳細ページへ遷移する' do
    visit post_path(another_post.id)
    expect(page).to have_content "#{another_user.name}"
    click_link "#{another_user.name}さん"
    expect(current_path).to eq user_path(another_user.id)
  end

  scenario '自分の投稿の場合は自分の名前が表示されないこと' do
    visit post_path(post.id)
    expect(page).to_not have_content '投稿者'
  end

  scenario 'いいねするとハートの色が変わるか', js: true do
    click_link '💙'
    expect(page).to have_content '❤️'
    expect(page).to_not have_content '💙'
    click_link '❤️'
    expect(page).to have_content '💙'
    expect(page).to_not have_content '❤️'
  end

  scenario 'コメントをするとコメント内容が表示されるか', js: true do
    fill_in 'post_comment_comment', with: 'test_comment'
    click_button '送信'
    expect(page).to have_content 'test_comment'
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

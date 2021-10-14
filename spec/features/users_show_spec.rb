require 'rails_helper'

feature 'ユーザー詳細ページ' do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let(:genre) { create(:genre) }
  let!(:users_post) { create(:post, user_id: user.id, genre_id: genre.id) }
  let!(:another_users_post) { create(:post, user_id: another_user.id, genre_id: genre.id) }

  before do
    # 4行目のユーザーとしてログイン
    log_in(user.email)
    visit user_path(user.id)
  end

  scenario 'ログインユーザーの投稿のみ表示されているか' do
    expect(current_path).to eq user_path(user.id)
    expect(page).to have_content "#{users_post.title}"
    expect(page).not_to have_content "#{another_users_post.title}"

    # 投稿一覧ページなら、両方のユーザーの投稿が表示される
    visit posts_path
    expect(page).to have_content "#{users_post.title}"
    expect(page).to have_content "#{another_users_post.title}"
  end

  scenario 'ログインユーザーのプロフィールが表示されているか' do
    expect(page).to have_content "#{user.name}"
    expect(page).to have_content "#{user.introduction}"
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

  feature 'ヘッダーのリンク' do
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
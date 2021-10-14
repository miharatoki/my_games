require 'rails_helper'

feature '投稿一覧ページ' do
  let!(:genre) { create(:genre) }
  let!(:user) { create(:user, email: 'test@test.com') }
  let!(:post) { create(:post, genre_id: genre.id, user_id: user.id) }
  let(:another_user) { create(:user) }

  before do
    log_in(user.email)
  end

  scenario '全てのユーザーの投稿が表示されているか' do
    user_array = [user, another_user]
    user_array.each { |user| create(:post, genre_id: genre.id, user_id: user.id) }
    visit posts_path

    expect(current_path).to eq posts_path
    expect(page).to have_content "#{user.name}"
    expect(page).to have_content "#{another_user.name}"
  end

  scenario '1ページに６レコードずつ表示されているか' do
    for num in 1..10 do
      create(:post, user_id: user.id, genre_id: genre.id, title: "test#{num}")
    end

    visit posts_path
    expect(current_path).to eq posts_path
    # 1ページに6レコードずつ、デフォルトで降順でレコードを表示するため
    for num in 5..10 do
      expect(page).to have_content "test#{num}"
    end
    click_link '次へ'
    for num in 1..4 do
      expect(page).to have_content "test#{num}"
    end
  end

  scenario 'ゲームタイトルを押下すると投稿詳細ページに遷移できるか' do
    visit posts_path
    expect(current_path).to eq posts_path
    click_on "#{post.title}"
    expect(current_path).to eq post_path("#{post.id}")
  end

  scenario '投稿者名を押下するとユーザ詳細ページに遷移するか' do
    visit posts_path
    expect(current_path).to eq posts_path
    click_on "#{user.name}さん"
    expect(current_path).to eq user_path(user.id)
  end

  scenario '並び替えができるか', js: true do
    high_score_post = create(:post, user_id: user.id, genre_id: genre.id, total_score: 5)
    row_score_post = create(:post, user_id: user.id, genre_id: genre.id, total_score: 4)

    visit posts_path
    expect(current_path).to eq posts_path
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
    action = create(:genre, name: 'アクション')
    shooting = create(:genre, name: 'シューティング')
    action_post = create(:post, user_id: user.id, genre_id: action.id)
    shooting_post = create(:post, user_id: user.id, genre_id: shooting.id)

    visit posts_path
    expect(current_path).to eq posts_path
    # 両方とも表示されている
    expect(page).to have_content "#{shooting_post.title}"
    expect(page).to have_content "#{action_post.title}"

    select 'シューティング', from: 'select'
    # 検索したジャンル名「シューティング」のレコードのみ表示されている
    expect(page).to have_content "#{shooting_post.title}"
    expect(page).not_to have_content "#{action_post.title}"
  end

  scenario '作品名で検索ができる' do
    test1_post = create(:post)
    test2_post = create(:post)

    visit posts_path
    expect(current_path).to eq posts_path
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
    before do
      visit posts_path
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

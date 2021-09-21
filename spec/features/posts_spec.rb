require 'rails_helper'

feature '新規投稿ページ' do
  before do
    create(:genre)
    user = create(:user, email: 'test@test.com')
    log_in(user.email)
    visit new_post_path
  end

  feature '新規投稿をできるか' do
    scenario '有効な内容なら保存できる', js: true do
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
      # expect(page).to have_content 'を入力してください'
    end
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
end

feature '投稿一覧ページ' do
  before do
    create(:user, email: 'test@test.com')
    log_in('test@test.com')
  end

  scenario '全ての投稿が表示されているか', js: true do
    user = create(:user)
    genre = create(:genre)
    10.times do
      create(:post, user_id: user.id, genre_id: genre.id)
    end
    
    visit posts_path
    expect(current_path).to eq posts_path
    # 1ページに6レコードずつ、デフォルトで降順でレコードを表示するため
    for num in 5..10 do
      expect(page).to have_content "title#{num}"
    end
    click_link 'Next'
    for num in 1..4 do
      expect(page).to have_content "title#{num}"
    end
  end
  
  scenario 'タイトルを押下すると投稿詳細ページに遷移できるか' do
    user = create(:user)
    genre = create(:genre)
    post = create(:post, user_id: user.id, genre_id: genre.id)
    
    visit posts_path
    expect(current_path).to eq posts_path
    click_on "#{post.title}"
    expect(current_path).to eq post_path("#{post.id}")
  end
  
  scenario '投稿者名を押下するとユーザ詳細ページに遷移するか' do
    user = create(:user)
    genre = create(:genre)
    create(:post, user_id: user.id, genre_id: genre.id)
    
    visit posts_path
    expect(current_path).to eq posts_path
    click_on "#{user.name}さん"
    expect(current_path).to eq user_path(user.id)
  end
  
  scenario '並び替えができるか', js: true do
    user = create(:user)
    genre = create(:genre)
    high_score_post = create(:post, user_id: user.id, genre_id: genre.id, total_score: 5)
    row_score_post = create(:post, user_id: user.id, genre_id: genre.id, total_score: 1)
    
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
    user = create(:user)
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
end


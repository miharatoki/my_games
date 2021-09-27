require 'rails_helper'

feature '新規投稿ページ' do
  before do
    create(:genre)
    @user = create(:user, email: 'test@test.com')
    log_in(@user.email)
    visit new_post_path
  end

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

feature '投稿一覧ページ' do
  before do
    @user = create(:user, email: 'test@test.com')
    log_in(@user.email)
  end

  scenario '全ての投稿が表示されているか', js: true do
    user = create(:user)
    genre = create(:genre)
    for num in 1..10 do
      create(:post, user_id: user.id, genre_id: genre.id, title: "test#{num}")
    end

    visit posts_path
    expect(current_path).to eq posts_path
    # 1ページに6レコードずつ、デフォルトで降順でレコードを表示するため
    for num in 5..10 do
      expect(page).to have_content "test#{num}"
    end
    click_link 'Next'
    for num in 1..4 do
      expect(page).to have_content "test#{num}"
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

feature '投稿詳細ページ' do
  before do
    @user = create(:user)
    genre = create(:genre)
    @post = create(:post, user_id: @user.id, genre_id: genre.id)
    create(:post_comment, user_id: @user.id, post_id: @post.id, comment: 'test')
    log_in(@user.email)
    visit post_path(@post.id)
    expect(current_path).to eq post_path(@post.id)
  end

  scenario '自分の投稿の場合は編集ボタンと削除ボタンが表示されている' do
    edit = find('.btn-info')
    destroy = find('.btn-danger')
    expect(edit[:href]).to eq edit_post_path(@post.id)
    expect(destroy[:href]).to eq post_path(@post.id)
  end

  scenario '編集ボタンを押すと投稿編集ページに遷移するか' do
    find('.btn-info').click
    expect(current_path).to eq edit_post_path(@post.id)
  end

  scenario '削除ボタンを押すとダイアログが表示され、キャンセル、okが選択できるか' do
    find('.btn-danger').click
    expect {
      expect(page).to have_content 'キャンセル'
      expect(page).to have_content 'OK'
    }
  end

  scenario '削除ボタンのokを押すと投稿が削除される' do
    find('.btn-danger').click
    expect {
      page.accept_confirm("本当に削除しますか？")
      expect(page).to have_content '記録を削除しました'
       post = Post.find_by(id: @post.id)
      expect(post).to eq nil
    }

  end

  scenario '自分の投稿の場合は自分の名前が表示されない' do
    expect(page).to_not have_content "投稿者："
  end

  scenario '自分以外の投稿の場合は変集ボタンと削除ボタンが表示されていないか' do
    post = create(:post)
    visit post_path(post.id)
    expect(all('.btn-info').empty?).to eq true
    expect(all('.btn-danger').empty?).to eq true
  end

  scenario '自分以外の投稿の場合は投稿者名が表示されていて、押下するとユーザ詳細ページへ遷移する' do
    post = create(:post)
    visit post_path(post.id)
    expect(page).to have_content "#{post.user.name}"
    click_link "#{post.user.name}さん"
    expect(current_path).to eq user_path(post.user.id)
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

feature '投稿編集ページ' do
  before do
    @user = create(:user)
    genre = create(:genre)
    create(:genre, name: 'シューティング')
    @post = create(:post, user_id: @user.id, genre_id: genre.id)
    log_in(@user.email)
    visit edit_post_path(@post.id)
    expect(current_path).to eq edit_post_path(@post.id)
  end


  scenario '投稿内容の編集ができるか', js: true do
    fill_in 'post_title', with: 'edit_title'
    fill_in 'post_body', with: 'edit_body'
    select 'シューティング', from: 'post_genre_id'
    find("#total-score-#{@post.id}").find("img[alt='1']").click
    find("#story-score-#{@post.id}").find("img[alt='1']").click
    find("#graphic-score-#{@post.id}").find("img[alt='1']").click
    find("#sound-score-#{@post.id}").find("img[alt='1']").click
    find("#operability-score-#{@post.id}").find("img[alt='1']").click
    find("#balance-score-#{@post.id}").find("img[alt='1']").click
    click_button '記録する'
    expect(current_path).to eq post_path(@post.id)
    expect(page).to have_content '記録を更新しました'
    visit edit_post_path(@post.id)
    expect(find('#post_title')['value']).to eq 'edit_title'
  end

  scenario '変更内容を削除ボタンを押すと書き換えた箇所が削除されるか', js: true do
    fill_in 'post_title', with: 'edit_title'
    expect(find('#post_title')['value']).to eq "edit_title"
    click_button '変更内容を削除'
    expect(find('#post_title')['value']).to eq "#{@post.title}"
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

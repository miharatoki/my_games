require 'rails_helper'

feature 'ログイン前' do
  let!(:user) { create(:user) }
  let!(:genre) { create(:genre) }
  let!(:post) { create(:post, user_id: user.id, genre_id: genre.id) }

  feature 'アクセス制限' do
    # 未ログイン時にアクセスしようとするとログインページに遷移する
    scenario '新規投稿ページにアクセスできないこと' do
      visit new_post_path
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(current_path).to eq new_user_session_path
    end

    scenario '投稿一覧ページに遷移できないこと' do
      visit posts_path
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(current_path).to eq new_user_session_path
    end

    scenario '投稿詳細ページに遷移できないこと' do
      visit post_path(post.id)
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(current_path).to eq new_user_session_path
    end

    scenario '投稿編集ページに遷移できないこと' do
      visit edit_post_path(post.id)
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(current_path).to eq new_user_session_path
    end

    scenario 'ユーザー詳細ページに遷移できないこと' do
      visit user_path(user.id)
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(current_path).to eq new_user_session_path
    end

    scenario 'ユーザ編集ページに遷移できないこと' do
      visit edit_user_path(user.id)
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(current_path).to eq new_user_session_path
    end

    scenario '通知一覧ページに遷移できないこと' do
      visit user_notifications_path(user.id)
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(current_path).to eq new_user_session_path
    end
  end

  feature 'トップページから新規登録、ログイン、ゲストログイン' do
    before do
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
        expect(page).to have_content '通知'
        expect(page).to have_content '自分の記録'
        expect(page).to have_content 'みんなの記録'
        expect(page).to have_content '新しく記録する'
        expect(page).to have_content 'ログアウト'
        expect(current_path).to eq posts_path
      end

      scenario 'ヘッダーのログインをクリックするとログインページへ遷移する' do
        click_link 'ログイン'
        expect(current_path).to eq new_user_session_path
      end

      scenario 'ヘッダーのゲストサインインをクリックするとゲストユーザーとしてログインする' do
        click_link 'ゲストログイン'
        expect(page).to have_content 'ゲストユーザーとしてログインしました'
        expect(current_path).to eq posts_path
      end

      scenario 'ヘッダーのロゴをクリックするとトップページへ遷移する' do
        click_link 'My Games'
        expect(current_path).to eq root_path
      end
    end

    feature 'ログイン' do
      let!(:user) { create(:user) }

      before do
        click_link 'アカウントをお持ちの方'
      end

      scenario 'ログインページに遷移できるか' do
        expect(current_path).to eq new_user_session_path
      end

      scenario 'ログイン時にフラッシューメッセージとヘッダーが表示されているか' do
        fill_in 'user_email', with: "#{user.email}"
        fill_in 'user_password', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'ログインしました'
        expect(page).to have_content '通知'
        expect(page).to have_content '自分の記録'
        expect(page).to have_content 'みんなの記録'
        expect(page).to have_content '新しく記録する'
        expect(page).to have_content 'ログアウト'
        expect(current_path).to eq posts_path
      end

      scenario 'ヘッダーの新規登録をクリックすると新規登録ページへ遷移する' do
        click_link '新規登録'
        expect(current_path).to eq new_user_registration_path
      end

      scenario 'ヘッダーのゲストサインインをクリックするとゲストユーザーとしてログインする' do
        click_link 'ゲストログインはこちら'
        expect(page).to have_content 'ゲストユーザーとしてログインしました'
        expect(current_path).to eq posts_path
      end

      scenario 'ヘッダーのロゴをクリックするとトップページへ遷移する' do
        click_link 'My Games'
        expect(current_path).to eq root_path
      end
    end

    feature 'ゲストログイン' do
      scenario 'トップページののゲストログインボタンを押下' do
        click_link 'ゲストログイン'
        expect(page).to have_content 'ゲストユーザーとしてログインしました'
        expect(current_path).to eq posts_path
      end
    end
  end
end

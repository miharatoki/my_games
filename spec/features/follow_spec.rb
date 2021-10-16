require 'rails_helper'

feature 'フォロー' do
  feature 'フォローされる' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }

    before do
      log_in(user.email)
      visit user_path(other_user.id)
    end

    feature 'ユーザー詳細ページ' do
      scenario 'ユーザーをフォローすると、フォロー解除のリンクが表示されるか', js: true do
        click_link 'フォローする'
        expect(page).to have_content 'フォロー解除'
      end

      scenario 'フォローすると、そのユーザーのフォロワー数の数字が増えるか', js: true do
        expect(page). to have_content '0 フォロワー'
        click_link 'フォローする'
        expect(page). to have_content '1 フォロワー'
      end

      scenario 'フォロワー数をクリックするとフォロワー一覧ページに遷移するか', js: true do
        click_link '0 フォロワー'
        expect(current_path).to eq user_followers_path(other_user.id)
      end
    end

    feature 'フォロワー一覧ページ' do
      before do
        click_link 'フォローする'
        wait_for_ajax do
          click_link '1 フォロワー'
        end
      end

      scenario 'フォロワーが表示されているか', js: true do
        expect(page).to have_content "#{user.name}"
        expect(page).to have_content "#{user.introduction}"
      end
    end
  end

  feature 'フォローする' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }

    before do
      log_in(user.email)
      visit user_path(other_user.id)
      click_link 'フォローする'
      visit user_path(user.id)
    end

    feature 'ユーザー詳細ページ' do
      scenario '自分の詳細ページのフォロー数が増えているか', js: true do
        expect(page).to have_content '1 フォロー'
      end

      scenario 'フォロー数をクリックするとフォロー中一覧ページに遷移するか', js: true do
        click_link '1 フォロー'
        expect(current_path).to eq user_following_path(user.id)
      end
    end

    feature 'フォロー中一覧ページ' do
      before do
        click_link '1 フォロー'
      end

      scenario 'フォロー中一覧ページにフォロー中のユーザーが表示されているか', js: true do
        expect(page).to have_content "#{other_user.name}"
        expect(page).to have_content "#{other_user.introduction}"
      end

      scenario 'フォロー解除をクリックするとフォローが解除されるか', js: true do
        click_link 'フォロー解除'
        expect(page).not_to have_content "#{other_user.name}"
      end
    end
  end
end

require 'rails_helper'

feature '新規投稿' do
  before do
    create(:genre)
    user = create(:user, email: 'test@test.com')
    log_in(user.email)
    visit new_post_path
  end
  
  scenario '新規投稿ができるか', js: true do
    expect(current_path).to eq new_post_path
    fill_in 'post_title', with: 'test_post'
    select 'アクション', from: 'post_genre_id'
    fill_in 'post_body', with: 'test_body'
    find('#total-score').find("img[alt='5']").click
    click_button '記録する'
    expect(page).to have_content 'を入力してください'
  end
end
require 'rails_helper'

RSpec.describe 'Favoriteモデルのテスト' do
  let!(:post) {create(:post)}
  let!(:favorite) {create(:favorite, post_id: post.id)}
  
  it 'postを削除すると、紐づいたfavoriteも削除されるか' do
    post.destroy
    expect(Favorite.find_by(post_id: favorite.id)).to eq nil
  end
  
  context 'アソシエーション' do
    it 'Userモデルと多対1の関係であるか' do
      expect(Favorite.reflect_on_association(:user).macro).to eq :belongs_to
    end
    it 'Postモデルと多対1の関係であるか' do
      expect(Favorite.reflect_on_association(:post).macro).to eq :belongs_to
    end
    it 'Notificationモデルと多対1の関係であるか' do
      expect(Favorite.reflect_on_association(:notifications).macro).to eq :has_many
    end
  end

end
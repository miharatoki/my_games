require 'rails_helper'

RSpec.describe 'Notificationモデルのテスト' do
  let!(:sender) {create(:user)}
  let!(:receiver) {create(:user)}
  let!(:post) {create(:post, user_id: receiver.id)}
  let!(:favorite) {create(:favorite, post_id: post.id, user_id: sender.id)}
  let!(:post_comment) {create(:post_comment, post_id: post.id, user_id: sender.id)}
  let!(:favorite_notification) {create(:notification, favorite_id: favorite.id, sender_id: sender.id, receiver_id: receiver.id, action: 'favorite')}
  let!(:post_comment_notification) {create(:notification, post_comment_id: post_comment.id, sender_id: sender.id, receiver_id: receiver.id, action: 'post_comment')}
  
  context '通知内容がアクションと同じか' do
    it 'いいねした場合' do
      expect(favorite_notification.action).to eq 'favorite'
    end
    
    it 'コメントした場合' do
      expect(post_comment_notification.action).to eq 'post_comment'
    end
  end

  context '親モデルのレコードが削除された時に紐づけられたnotificationのレコードも削除されるか' do
    it '全件取得' do 
      expect(Notification.all.count).to eq 2
    end
    
    # Postモデルと直接紐づいていないためPostモデルと直接紐づいているPostCommentモデルPKを使用
    it 'Postモデルのレコードを削除した時(post_comment.id)' do
      post.destroy
      expect(Notification.find_by(post_comment_id: post_comment.id)).to eq nil
    end
    
    # FavoriteモデルもPostモデルと直接紐づいているため、同じようにテスト
    it 'Postモデルのレコードを削除した時(favorite.id)' do
      post.destroy
      expect(Notification.find_by(favorite_id: favorite.id)).to eq nil
    end
    
    # いいねを解除した時
    it 'Favoriteモデルのレコードを削除した時' do
      favorite.destroy
      expect(Notification.all.count).to eq 1
      expect(Notification.find_by(favorite_id: favorite_notification.favorite_id)).to eq nil
    end
    
    # 投稿へのコメントを消した時
    it 'PostCommentモデルのレコードを削除した時' do
      post_comment.destroy
      expect(Notification.all.count).to eq 1
      expect(Notification.exists?(post_comment_id: post_comment_notification.post_comment_id)).to eq false
    end
  end
  
  context 'アソシエーション' do
    
    it 'favoriteモデルと多対1の関係である' do
      expect(Notification.reflect_on_association(:favorite).macro).to eq :belongs_to
    end
    
    it 'post_commentモデルと多対1の関係である' do
      expect(Notification.reflect_on_association(:post_comment).macro).to eq :belongs_to
    end
  end

end
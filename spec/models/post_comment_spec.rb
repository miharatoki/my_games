require 'rails_helper'

RSpec.describe 'PostCommentモデルのテスト' do
  subject { post_comment.valid? }
  let!(:post) {create(:post)}
  let!(:post_comment) {build(:post_comment)}
  
  context '親モデルのレコードを削除すると紐づいたPostCommentのレコードが削除されるか' do
    let(:post_comment) {create(:post_comment, post_id: post.id)}
  
    it 'Postのレコードを削除した時' do
      post.destroy
      expect(PostComment.find_by(post_id: post.id)).to eq nil
    end
  end

  context 'バリデーション' do
    it '空白では保存できないこと' do
      post_comment.comment = ''
      is_expected.to eq false
    end
    it '1文字では保存できないこと' do
      post_comment.comment = Faker::Lorem.characters(number: 1)
      is_expected.to eq false
      expect(post_comment.errors[:comment]).to include('は2文字以上で入力してください')
    end
    it '2文字なら保存できること' do
      post_comment.comment = Faker::Lorem.characters(number: 2)
      is_expected.to eq true
    end
    it '141文字なら保存できること' do
      post_comment.comment = Faker::Lorem.characters(number: 141)
      is_expected.to eq false
      expect(post_comment.errors[:comment]).to include('は140文字以内で入力してください')
    end
    it '140文字ちょうどなら保存できること' do
      post_comment.comment = Faker::Lorem.characters(number: 140)
      is_expected.to eq true
    end
  end

  context 'アソシエーション' do
    it 'Userモデルと多対1の関係であること' do
      expect(PostComment.reflect_on_association(:user).macro).to eq :belongs_to
    end
    it 'PostCommentモデルと多対1の関係であること' do
      expect(PostComment.reflect_on_association(:post).macro).to eq :belongs_to
    end
    it 'Notificationモデルと1対多の関係であること' do
      expect(PostComment.reflect_on_association(:notifications).macro).to eq :has_many
    end
  end



end
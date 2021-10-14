require 'rails_helper'

RSpec.describe 'Userモデルのテスト' do
  # userのバリデーションが通ったらtrue,通らなかったらfalse
  # is_expectedでsubjectの内容を評価
  subject { user.valid? }

  let!(:other_user) { create(:user) }
  let!(:user) { build(:user) }

  context 'nameカラムのバリデーション' do
    it '空白で保存できないこと' do
      user.name = ''
      is_expected.to eq false
      expect(user.errors[:name]).to include('が入力されていません。')
    end

    it '1文字では保存できないこと' do
      user.name = Faker::Lorem.characters(number: 1)
      is_expected.to eq false
      expect(user.errors[:name]).to include('は2文字以上で入力してください')
    end

    it '2文字だと保存できること' do
      user.name = Faker::Lorem.characters(number: 2)
      is_expected.to eq true
    end

    it '10文字以上では保存できないこと' do
      user.name = Faker::Lorem.characters(number: 11)
      is_expected.to eq false
      expect(user.errors[:name]).to include('は10文字以内で入力してください')
    end

    it '10文字ちょうどだと保存できること' do
      user.name = Faker::Lorem.characters(number: 10)
      is_expected.to eq true
    end
  end

  context 'introductionカラムのバリデーション' do
    it '141文字以上だと保存できないこと' do
      user.introduction = Faker::Lorem.characters(number: 141)
      is_expected.to eq false
      expect(user.errors[:introduction]).to include('は140文字以内で入力してください')
    end

    it '140文字ちょうどだと保存できること' do
      user.introduction = Faker::Lorem.characters(number: 140)
      is_expected.to eq true
    end
  end

  context 'アソシエーション' do
    it 'Postモデルと1対多の関係であること' do
      expect(User.reflect_on_association(:posts).macro).to eq :has_many
    end

    it 'PostCommentモデルと1対多の関係であること' do
      expect(User.reflect_on_association(:post_comments).macro).to eq :has_many
    end
  end
end

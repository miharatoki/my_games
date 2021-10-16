require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  subject { post.valid? }

  let!(:post) { build(:post) }

  context '空白で保存した時のバリデーション' do
    it 'titleを空白で保存できないこと' do
      post.title = ''
      is_expected.to eq false
      expect(post.errors[:title]).to include('が入力されていません。')
    end

    it 'bodyを空白で保存できないこと' do
      post.body = ''
      is_expected.to eq false
      expect(post.errors[:body]).to include('が入力されていません。')
    end

    it 'total_scoreを空白で保存できないこと白' do
      post.total_score = ''
      is_expected.to eq false
      expect(post.errors[:total_score]).to include('が入力されていません。')
    end

    it 'story_scoreを空白で保存できないこと' do
      post.story_score = ''
      is_expected.to eq false
      expect(post.errors[:story_score]).to include('が入力されていません。')
    end

    it 'graphic_scoreを空白で保存できないこと' do
      post.graphic_score = ''
      is_expected.to eq false
      expect(post.errors[:graphic_score]).to include('が入力されていません。')
    end

    it 'operability_scoreを空白で保存できないこと' do
      post.operability_score = ''
      is_expected.to eq false
      expect(post.errors[:operability_score]).to include('が入力されていません。')
    end

    it 'sound_scoreを空白で保存できないこと' do
      post.sound_score = ''
      is_expected.to eq false
      expect(post.errors[:sound_score]).to include('が入力されていません。')
    end

    it 'balance_scoreを空白で保存できないこと' do
      post.balance_score = ''
      is_expected.to eq false
      expect(post.errors[:balance_score]).to include('が入力されていません。')
    end
  end

  context 'titleとbodyの文字制限のバリデーション' do
    it 'titleを30文字以上で保存しようとした時はエラー' do
      post = Post.new(title: Faker::Lorem.characters(number: 31))
      expect(post).to be_invalid
      expect(post.errors[:title]).to include('は30文字以内で入力してください')
    end

    it 'bodyを400文字以上で保存しようとした時はエラー' do
      post = Post.new(body: Faker::Lorem.characters(number: 401))
      expect(post).to be_invalid
      expect(post.errors[:body]).to include('は400文字以内で入力してください')
    end

    it 'titleを30文字ちょうどで保存しようとした時は保存できること' do
      post.title = Faker::Lorem.characters(number: 30)
      expect(post).to be_valid
    end

    it 'bodyを400文字ちょうどで保存しようとした時は保存できること' do
      post.body = Faker::Lorem.characters(number: 400)
      expect(post).to be_valid
    end
  end

  context 'アソシエーション' do
    it 'Userモデルと多対1の関係であること' do
      expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it 'Genreモデルと多対1の関係であること' do
      expect(Post.reflect_on_association(:genre).macro).to eq :belongs_to
    end

    it 'PostCommentモデルと1対多の関係であること' do
      expect(Post.reflect_on_association(:post_comments).macro).to eq :has_many
    end
  end
end

require 'rails_helper'

RSpec.describe 'Genreモデルのテスト' do
  let!(:genre) { create(:genre) }

  it 'Postモデルと1対多の関係であるか' do
    expect(Genre.reflect_on_association(:posts).macro).to eq :has_many
  end
end

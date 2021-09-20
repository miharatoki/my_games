FactoryBot.define do
  factory :notification do
    association :post_comment
    association :favorite
    association :sender, factory: :user
    association :receiver, factory: :user
  end
end
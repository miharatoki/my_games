FactoryBot.define do
  factory :notification do
    association :post_comment
    association :favorite
    association :sender, factory: :user
    association :receiver, factory: :sender
  end
end

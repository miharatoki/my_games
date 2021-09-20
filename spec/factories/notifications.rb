FactoryBot.define do
  factory :notification do
    association :post_comment
    association :favorite
    association :sender, factory: :user
    association :receiver, factory: :user
    check {false}
  end
end
FactoryBot.define do
  factory :post_comment do
    association :user
    association :post
    comment { Faker::Lorem.characters(number: 10) }
  end
end

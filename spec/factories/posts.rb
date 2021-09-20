FactoryBot.define do
  factory :post do
    association :user
    association :genre
    title {Faker::Lorem.characters(number: 10)}
    body {Faker::Lorem.characters(number: 30)}
    total_score {5}
    story_score {4}
    operability_score {3}
    sound_score {2}
    balance_score {1}
    graphic_score {2}
  end
end
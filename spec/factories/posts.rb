FactoryBot.define do
  factory :post do
    association :user
    association :genre
    sequence(:title) {|n| "title#{n}"}
    body {Faker::Lorem.characters(number: 30)}
    total_score {1}
    story_score {2}
    operability_score {3}
    sound_score {4}
    balance_score {5}
    graphic_score {1}
  end
end
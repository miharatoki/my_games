FactoryBot.define do
  factory :genre do
    name {Faker::Lorem.characters(number: 5)}
  end
end
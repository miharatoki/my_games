FactoryBot.define do
  factory :user do
    sequence(:name) {|n| "tester#{n}"}
    sequence(:email) {|n| "tester#{n}@example.com"}
    introduction {Faker::Lorem.characters(number:20)}
    profile_image_id {''}
    password {'password'}
    password_confirmation { 'password' }
  end

end

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@example.com" }
    name { "Foo" }
    surname { "Bar" }
    password { '12341234' }
  end
end

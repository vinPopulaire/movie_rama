FactoryBot.define do
  factory :movie do
    title { 'Title' }
    description { 'Description' }
    association :user, factory: :user
  end
end

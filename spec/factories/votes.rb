FactoryBot.define do
  factory :vote do
    association :user, factory: :user
    association :movie, factory: :movie

    action { :like }

    trait :like do
      action { :like }
    end

    trait :hate do
      action { :hate }
    end
  end
end

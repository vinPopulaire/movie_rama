FactoryBot.define do
  factory :user_movie_preference do
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

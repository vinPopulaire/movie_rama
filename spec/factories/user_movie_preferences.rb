FactoryBot.define do
  factory :user_movie_preference do
    association :user, factory: :user
    association :movie, factory: :movie

    action { :like }
  end
end

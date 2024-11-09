# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

USERS_NUM = 100
MOVIES_NUM = 300

puts "Creating users"

USERS_NUM.times do
  User.create!(
    email: Faker::Internet.email,
    name: Faker::Name.first_name,
    surname: Faker::Name.last_name,
    password: "12341234")
end

puts "#{User.count} users created"

users = User.all.to_a

puts "Creating movies"

MOVIES_NUM.times do |n|
  Movie.create!(
    title: Faker::Movie.title,
    description: Faker::Lorem.paragraph(sentence_count: rand(30..60)),
    user_id: users.sample.id,
    created_at: Faker::Date.between(from: '2014-09-23', to: '2024-08-25')
  )
end

puts "#{Movie.count} movies created"

movies = Movie.all.to_a

puts "Creating votes"

users.each do |user|
  movies_to_vote = movies.sample(rand(10..60)).pluck(:id)

  movies_to_vote.each do |movie_id|
    Vote.create!(
      movie_id: movie_id,
      user_id: user.id,
      action: rand(2)
    )
  end
end

puts "#{Vote.count} votes created"

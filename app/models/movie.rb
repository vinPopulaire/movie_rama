class Movie < ApplicationRecord
  belongs_to :user
  has_many :user_movie_preferences, dependent: :destroy
  has_many :likes, -> { where(action: :like) }, class_name: "UserMoviePreference"
  has_many :hates, -> { where(action: :hate) }, class_name: "UserMoviePreference"

  validates :title, presence: true
  validates :description, presence: true
  validates :user, presence: true

  def self.order_by_likes
    Movie.left_joins(:likes).
      group("movies.id").
      order("COUNT(user_movie_preferences.id) DESC")
  end

  def self.order_by_hates
    Movie.left_joins(:hates).
      group("movies.id").
      order("COUNT(user_movie_preferences.id) DESC")
  end
end

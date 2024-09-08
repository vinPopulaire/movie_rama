class Movie < ApplicationRecord
  belongs_to :user
  has_many :user_movie_preferences, dependent: :destroy
  has_many :likes, -> { where(action: :like) }, class_name: "UserMoviePreference"
  has_many :hates, -> { where(action: :hate) }, class_name: "UserMoviePreference"

  validates :title, presence: true
  validates :description, presence: true
  validates :user, presence: true

  def self.order_by_likes
    Movie.select("movies.*, COUNT(movies.id) AS like_count").
          left_joins(:likes).
          group("movies.id").
          order("like_count DESC")
  end

  def self.order_by_hates
    Movie.select("movies.*, COUNT(movies.id) AS hate_count").
          left_joins(:hates).
          group("movies.id").
          order("hate_count DESC")
  end

  # TODO: Fix needed, this will not perform well with many likes and dislikes because if will fetch all likes into memory
  def like_count
    likes.length
  end

  def hate_count
    hates.length
  end
end

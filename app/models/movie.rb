class Movie < ApplicationRecord
  belongs_to :user
  has_many :user_movie_preferences, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :user, presence: true

  def like_count
    user_movie_preferences.like.count
  end

  def hate_count
    user_movie_preferences.hate.count
  end
end

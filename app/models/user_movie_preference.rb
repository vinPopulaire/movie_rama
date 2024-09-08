class UserMoviePreference < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :user, presence: true
  validates :movie, presence: true
  validates :action, presence: true

  validates_uniqueness_of :movie, scope: :user_id

  enum :action, {
    like: 0,
    hate: 1
  }
end

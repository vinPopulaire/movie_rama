class Movie < ApplicationRecord
  include PgSearch::Model

  belongs_to :user
  has_many :votes, dependent: :destroy
  has_many :likes, -> { where(action: :like) }, class_name: "Vote"
  has_many :hates, -> { where(action: :hate) }, class_name: "Vote"

  validates :title, presence: true
  validates :description, presence: true
  validates :user, presence: true

  pg_search_scope :search_by_title, against: :title
end

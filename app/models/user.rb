class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :movies, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :name, presence: true
  validates :surname, presence: true

  def fullname
    name + " " + surname
  end
end

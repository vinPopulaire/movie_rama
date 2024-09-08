require 'rails_helper'

RSpec.describe UserMoviePreference, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:movie) }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :movie }
  it { is_expected.to validate_presence_of :action }

  it 'validates uniqueness of movie scoped to user' do
    FactoryBot.create(:user_movie_preference)

    is_expected.to validate_uniqueness_of(:movie).scoped_to(:user_id)
  end

  it { is_expected.to define_enum_for(:action).with_values([ :like, :hate ]) }
end

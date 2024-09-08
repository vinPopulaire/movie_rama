require "rails_helper"

RSpec.describe Movie, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:user_movie_preferences).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :user }
end

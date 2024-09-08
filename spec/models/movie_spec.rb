require "rails_helper"

RSpec.describe Movie, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:user_movie_preferences).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :user }

  describe '#like_count' do
    let(:movie) { FactoryBot.create(:movie) }
    let(:other_movie) { FactoryBot.create(:movie) }

    before do
      FactoryBot.create_list(:user_movie_preference, 3, movie: movie, action: 0)
      FactoryBot.create_list(:user_movie_preference, 2, movie: other_movie, action: 0)
      FactoryBot.create_list(:user_movie_preference, 6, movie: movie, action: 1)
      FactoryBot.create_list(:user_movie_preference, 5, movie: other_movie, action: 1)
    end

    subject { movie.like_count }

    it 'returns the correct number of likes' do
      expect(subject).to eq(3)
    end
  end

  describe '#hate_count' do
    let(:movie) { FactoryBot.create(:movie) }
    let(:other_movie) { FactoryBot.create(:movie) }

    before do
      FactoryBot.create_list(:user_movie_preference, 3, movie: movie, action: 0)
      FactoryBot.create_list(:user_movie_preference, 2, movie: other_movie, action: 0)
      FactoryBot.create_list(:user_movie_preference, 6, movie: movie, action: 1)
      FactoryBot.create_list(:user_movie_preference, 5, movie: other_movie, action: 1)
    end

    subject { movie.hate_count }

    it 'returns the correct number of likes' do
      expect(subject).to eq(6)
    end
  end
end

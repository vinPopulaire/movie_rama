require "rails_helper"

RSpec.describe Movie, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:user_movie_preferences).dependent(:destroy) }
  it { should have_many(:likes) }
  it { should have_many(:hates) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :user }

  describe 'associations' do
    let(:movie) { FactoryBot.create(:movie) }
    let!(:like) { FactoryBot.create(:user_movie_preference, :like, movie: movie) }
    let!(:hate) { FactoryBot.create(:user_movie_preference, :hate, movie: movie) }

    describe '.likes' do
      subject { movie.likes }

      it 'has many likes with the correct scope' do
        expect(subject).to include(like)
        expect(subject).not_to include(hate)
      end
    end

    describe '.hates' do
      subject { movie.hates }

      it 'has many likes with the correct scope' do
        expect(subject).to include(hate)
        expect(subject).not_to include(like)
      end
    end
  end

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

require "rails_helper"

RSpec.describe Movie, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:likes) }
  it { should have_many(:hates) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :user }

  describe 'associations' do
    let(:movie) { FactoryBot.create(:movie) }
    let!(:like) { FactoryBot.create(:vote, :like, movie: movie) }
    let!(:hate) { FactoryBot.create(:vote, :hate, movie: movie) }

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

  describe '.order_by_likes' do
    let(:movie_neutral) { FactoryBot.create(:movie) }
    let(:movie_liked) { FactoryBot.create(:movie) }
    let(:movie_hated) { FactoryBot.create(:movie) }

    subject { Movie.order_by_likes }

    before do
      FactoryBot.create_list(:vote, 5, :like, movie: movie_liked)
      FactoryBot.create_list(:vote, 3, :like, movie: movie_neutral)
      FactoryBot.create_list(:vote, 1, :like, movie: movie_hated)
      FactoryBot.create_list(:vote, 1, :hate, movie: movie_liked)
      FactoryBot.create_list(:vote, 3, :hate, movie: movie_neutral)
      FactoryBot.create_list(:vote, 5, :hate, movie: movie_hated)
    end

    it 'returns the movies with the correct ordering' do
      expect(subject).to eq([ movie_liked, movie_neutral, movie_hated ])
    end
  end

  describe '.order_by_hates' do
    let(:movie_neutral) { FactoryBot.create(:movie) }
    let(:movie_liked) { FactoryBot.create(:movie) }
    let(:movie_hated) { FactoryBot.create(:movie) }

    subject { Movie.order_by_hates }

    before do
      FactoryBot.create_list(:vote, 5, :like, movie: movie_liked)
      FactoryBot.create_list(:vote, 3, :like, movie: movie_neutral)
      FactoryBot.create_list(:vote, 1, :like, movie: movie_hated)
      FactoryBot.create_list(:vote, 1, :hate, movie: movie_liked)
      FactoryBot.create_list(:vote, 3, :hate, movie: movie_neutral)
      FactoryBot.create_list(:vote, 5, :hate, movie: movie_hated)
    end

    it 'returns the movies with the correct ordering' do
      expect(subject).to eq([ movie_hated, movie_neutral, movie_liked ])
    end
  end
end

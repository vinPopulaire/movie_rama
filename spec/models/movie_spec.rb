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
end

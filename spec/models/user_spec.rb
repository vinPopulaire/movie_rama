require "rails_helper"

RSpec.describe User, type: :model do
  it { should have_many(:movies).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :surname }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  describe '#fullname' do
    let(:name) { "Foo" }
    let(:surname) { "Bar" }
    let!(:user) { FactoryBot.create(:user) }

    it 'returns the correct full name' do
      expect(user.fullname).to eq('Foo Bar')
    end
  end
end

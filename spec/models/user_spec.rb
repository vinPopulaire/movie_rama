require "rails_helper"

RSpec.describe User, type: :model do
  it { should have_many(:movies).dependent(:destroy) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :surname }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
end

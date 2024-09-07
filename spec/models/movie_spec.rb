require "rails_helper"

RSpec.describe Movie, type: :model do
  it { should belong_to(:user) }
end

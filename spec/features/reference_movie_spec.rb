require 'rails_helper'

RSpec.describe 'Users should be able to filter movies based on the user that submitted them', type: :feature do
  scenario 'filter movies' do
    signup
    user = User.last

    FactoryBot.create(:user)
    FactoryBot.create(:movie, title: "Title1")
    movie = FactoryBot.create(:movie, title: "Title2")

    movie.update!(user_id: user.id)

    click_on user.fullname
    expect(page).to have_content("Title2")
    expect(page).not_to have_content('Title1')
  end
end

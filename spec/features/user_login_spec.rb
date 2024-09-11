require 'rails_helper'

RSpec.describe 'User should be able to login into their account', type: :feature do
  scenario 'valid inputs' do
    signup

    click_on 'Logout'
    click_on 'Login'
    fill_in 'Email', with: 'foo@mail.gr'
    fill_in 'Password', with: '12341234'
    click_on 'Log in'
    expect(page).to have_content('Signed in successfully.')
    visit movies_path
    expect(page).to have_content('New movie')
  end

  scenario 'invalid inputs' do
    signup

    click_on 'Logout'
    click_on 'Login'
    fill_in 'Email', with: 'foo@mail.gr'
    fill_in 'Password', with: 'unknown'
    click_on 'Log in'
    expect(page).to have_content("Invalid Email or password.")
    expect(page).not_to have_content('New movie')
  end
end

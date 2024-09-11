require 'rails_helper'

RSpec.describe 'User should be able to signup for a new account', type: :feature do
  scenario 'valid inputs' do
    visit new_user_registration_path
    fill_in 'Email', with: 'foo@mail.gr'
    fill_in 'Name', with: 'foo'
    fill_in 'Surname', with: 'bar'
    fill_in 'Password', with: '12341234'
    fill_in 'Password confirmation', with: '12341234'
    click_on 'Sign up'
    expect(page).to have_content('Welcome! You have signed up successfully.')
    visit movies_path
    expect(page).to have_content('New movie')
  end

  scenario 'invalid inputs' do
    visit new_user_registration_path
    fill_in 'Email', with: 'foo@mail.gr'
    click_on 'Sign up'
    expect(page).to have_content("Password can't be blank")
    visit movies_path
    expect(page).not_to have_content('New movie')
  end
end

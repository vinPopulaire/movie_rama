require 'rails_helper'

RSpec.describe 'User should be able to add a new movie', type: :feature do
  scenario 'logged in user' do
    signup

    visit movies_path
    expect(page).to have_content('New movie')

    click_on 'New movie'
    fill_in 'Title', with: 'test'
    fill_in 'Description', with: 'test2'
    click_on 'Create'

    expect(page).to have_content('test')
  end

  scenario 'logged in user but invalid movie' do
    signup

    visit movies_path
    expect(page).to have_content('New movie')

    click_on 'New movie'
    fill_in 'Title', with: 'test'
    click_on 'Create'

    expect(page).not_to have_content('test')
  end

  scenario 'logged out user' do
    signup

    visit movies_path
    expect(page).to have_content('New movie')
  end
end

require 'rails_helper'

RSpec.describe 'Users should be able to sort with number of likes/hates/date', type: :feature do
  scenario 'sort by likes' do
    signup

    FactoryBot.create(:movie, like_count: 10, hate_count: 0, title: 'Title1')
    FactoryBot.create(:movie, like_count: 0, hate_count: 10, title: 'Title2')

    click_on "Likes"

    titles = page.all('.movie h2').map(&:text)
    expect(titles).to eq([ 'Title1', 'Title2' ])
  end

  scenario 'sort by hates' do
    signup

    FactoryBot.create(:movie, like_count: 10, hate_count: 0, title: 'Title1')
    FactoryBot.create(:movie, like_count: 0, hate_count: 10, title: 'Title2')

    click_on "Hates"

    titles = page.all('.movie h2').map(&:text)
    expect(titles).to eq([ 'Title2', 'Title1' ])
  end

  scenario 'sort by date' do
    signup

    FactoryBot.create(:movie, title: 'Title1', created_at: 4.month.ago)
    FactoryBot.create(:movie, title: 'Title2', created_at: 3.month.ago)

    click_on "Date"

    titles = page.all('.movie h2').map(&:text)
    expect(titles).to eq([ 'Title2', 'Title1' ])
  end
end

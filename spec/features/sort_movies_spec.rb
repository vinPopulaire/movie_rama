require 'rails_helper'

RSpec.describe 'Users should be able to sort with number of likes/hates/date', type: :feature do
  scenario 'sort by likes' do
    signup

    movie_liked = FactoryBot.create(:movie, title: 'Title1')
    movie_hated = FactoryBot.create(:movie, title: 'Title2')
    FactoryBot.create_list(:vote, 2, :like, movie: movie_liked)
    FactoryBot.create_list(:vote, 1, :like, movie: movie_hated)

    click_on "Likes"

    titles = page.all('.movie h2').map(&:text)
    expect(titles).to eq([ 'Title1', 'Title2' ])
  end

  scenario 'sort by hates' do
    signup

    movie_liked = FactoryBot.create(:movie, title: 'Title1')
    movie_hated = FactoryBot.create(:movie, title: 'Title2')
    FactoryBot.create_list(:vote, 1, :hate, movie: movie_liked)
    FactoryBot.create_list(:vote, 2, :hate, movie: movie_hated)

    click_on "Hates"

    titles = page.all('.movie h2').map(&:text)
    expect(titles).to eq([ 'Title2', 'Title1' ])
  end

  scenario 'sort by date' do
    signup

    movie_older = FactoryBot.create(:movie, title: 'Title1', created_at: 4.month.ago)
    movie_newer = FactoryBot.create(:movie, title: 'Title2', created_at: 3.month.ago)

    click_on "Date"

    titles = page.all('.movie h2').map(&:text)
    expect(titles).to eq([ 'Title2', 'Title1' ])
  end
end

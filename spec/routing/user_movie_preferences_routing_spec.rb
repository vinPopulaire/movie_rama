require 'rails_helper'

RSpec.describe UserMoviePreferencesController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/user_movie_preferences').to route_to('user_movie_preferences#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/user_movie_preferences/1').to route_to('user_movie_preferences#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/user_movie_preferences/1').to route_to('user_movie_preferences#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/user_movie_preferences/1').to route_to('user_movie_preferences#destroy', id: '1')
    end
  end
end

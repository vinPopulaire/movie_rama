require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'GET index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @movies' do
      movie = FactoryBot.create(:movie)
      movie2 = FactoryBot.create(:movie)

      get :index
      expect(assigns(:movies)).to match_array([ movie, movie2 ])
    end

    it 'renders the index template' do
      get :index

      expect(response).to render_template('index')
    end

    context 'when a date filtering is chosen' do
      it 'assigns @movies with the correct ordering' do
        older_movie = FactoryBot.create(:movie, created_at: 2.month.ago)
        newer_movie = FactoryBot.create(:movie, created_at: 1.months.ago)

        get :index, params: { filter: 'date' }
        expect(assigns(:movies)).to eq([ newer_movie, older_movie ])
      end
    end

    context 'when a user filters is chosen' do
      let(:user1) { FactoryBot.create(:user) }
      let(:user2) { FactoryBot.create(:user) }

      let!(:movie1) { FactoryBot.create(:movie, user: user1) }
      let!(:movie2) { FactoryBot.create(:movie, user: user2) }

      it 'assigns @movies only of the correct user' do
        get :index, params: { filter: 'user', user_id: user1.id }
        expect(assigns(:movies)).to eq([ movie1 ])
      end
    end
  end

  describe 'GET new' do
    context 'when user is authenticated' do
      before do
        user = FactoryBot.create(:user)
        sign_in user
      end

      it 'assigns @movie' do
        get :new
        expect(assigns(:movie)).to be_a_new(Movie)
      end

      it 'renders the new template' do
        get :new
        expect(response).to render_template('new')
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to the login' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST create' do
    context 'when user is authenticated' do
      before do
        user = FactoryBot.create(:user)
        sign_in user
      end

      context 'with valid attributes' do
        let(:valid_attributes) { { title: 'foo', description: 'bar' } }

        it 'creates a new movie and assigns it to @movie' do
          expect {
            post :create, params: { movie: valid_attributes }
          }.to change(Movie, :count).by(1)

          expect(assigns(:movie)).to be_a(Movie)
          expect(assigns(:movie)).to be_persisted
        end

        it 'redirects to the movies index with a success notice' do
          post :create, params: { movie: valid_attributes }

          expect(response).to redirect_to(movies_path)
        end
      end

      context 'with invalid attributes' do
        let(:invalid_attributes) { { title: '', description: 'bar' } }

        it 'does not create a new movie' do
          expect {
            post :create, params: { movie: invalid_attributes }
          }.to_not change(Movie, :count)
        end

        it 'renders the new template with an error flash' do
          post :create, params: { movie: invalid_attributes }

          expect(response).to redirect_to(new_movie_path)
        end
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to the login' do
        post :create

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET edit' do
    context 'when user is authenticated' do
      before do
        user = FactoryBot.create(:user)
        sign_in user
      end

      let(:movie) { FactoryBot.create(:movie) }

      it 'assigns the requested movie to @movie' do
        get :edit, params: { id: movie.id }
        expect(assigns(:movie)).to eq(movie)
      end

      it 'renders the edit template' do
        get :edit, params: { id: movie.id }
        expect(response).to render_template('edit')
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to the login' do
        post :create

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH update' do
    let(:movie) { FactoryBot.create(:movie) }

    context 'when user is authenticated' do
      before do
        user = FactoryBot.create(:user)
        sign_in user
      end

      context 'with valid attributes' do
        let(:valid_attributes) { { title: 'foo', description: 'bar' } }

        it 'updates the movie and redirects to the movies index with a success notice' do
          patch :update, params: { id: movie.id, movie: valid_attributes }

          movie.reload
          expect(movie.title).to eq('foo')
          expect(movie.description).to eq('bar')
          expect(response).to redirect_to(movies_path)
          expect(flash[:notice]).to eq('Movie was successfully updated.')
        end
      end

      context 'with invalid attributes' do
        let(:invalid_attributes) { { title: '', description: 'Updated description' } }

        it 'does not update the movie and re-renders the edit template' do
          patch :update, params: { id: movie.id, movie: invalid_attributes }

          movie.reload
          expect(movie.title).not_to be_empty
          expect(response).to redirect_to(edit_movie_path)
        end
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to the login' do
        patch :update, params: { id: movie.id }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:movie) { FactoryBot.create(:movie) }

    context 'when user is authenticated' do
      before do
        user = FactoryBot.create(:user)
        sign_in user
      end

      it 'deletes the movie and redirects to the movies index with a success notice' do
        expect {
          delete :destroy, params: { id: movie.id }
        }.to change(Movie, :count).by(-1)

        expect(response).to redirect_to(movies_path)
        expect(flash[:notice]).to eq('Movie was successfully destroyed.')
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to the login' do
        delete :destroy, params: { id: movie.id }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end

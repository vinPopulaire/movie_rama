require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  shared_context 'actions without permission' do
    context 'when user is authenticated but is the owner of the movie' do
      before { sign_in user }

      let(:movie) { FactoryBot.create(:movie, user: user) }

      it 'redirects to the movie index with an error message' do
        subject

        expect(response).to redirect_to(movies_path)
        expect(flash[:alert]).to eq('You cannot vote your own movie')
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to the movies path' do
        subject

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST create' do
    let(:user) { FactoryBot.create(:user) }
    let(:movie) { FactoryBot.create(:movie) }
    let(:action) { :like }

    let(:parameters) do
      {
        movie_id: movie.id,
        user_action: action
      }
    end

    subject { post :create, params: parameters }

    context 'when user is authenticated' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'creates a new vote and assigns it to @vote' do
          expect { subject }.to change(Vote, :count).by(1)

          expect(assigns(:vote)).to be_a(Vote)
          expect(assigns(:vote)).to be_persisted
        end

        it 'redirects to the movies index with a success notice' do
          subject

          expect(response).to redirect_to(movies_path)
        end
      end

      context 'with invalid attributes' do
        let(:action) { :foo }

        it 'does not create a new vote' do
          expect { subject }.to_not change(Vote, :count)
        end

        it 'renders the new template with an error flash' do
          subject

          expect(response).to redirect_to(movies_path)
        end
      end
    end

    it_behaves_like 'actions without permission'
  end

  describe 'PATCH update' do
    let(:user) { FactoryBot.create(:user) }
    let(:movie) { FactoryBot.create(:movie) }
    let!(:vote) { FactoryBot.create(:vote, movie: movie, action: :hate) }
    let(:action) { :like }

    let(:parameters) do
      {
        id: vote.id,
        movie_id: movie.id,
        user_action: action
      }
    end

    subject { patch :update, params: parameters }

    context 'when user is authenticated' do
      before { sign_in user }

      context 'with valid attributes' do
        let!(:vote) { FactoryBot.create(:vote, movie: movie, user: user, action: :hate) }

        it 'updates the preference and redirects to the movies index with a success notice' do
          subject

          vote.reload
          expect(vote.action).to eq("like")
          expect(response).to redirect_to(movies_path)
          expect(flash[:notice]).to eq('Your vote has changed!')
        end

        context 'but the movie is owned by the user' do
          let(:movie) { FactoryBot.create(:movie, user: user) }

          it 'does not update the preference and redirects to the movies index with a success notice' do
            subject

            vote.reload
            expect(vote.action).to eq("hate")
            expect(response).to redirect_to(movies_path)
            expect(flash[:alert]).to eq('You cannot vote your own movie')
          end
        end
      end

      context 'with invalid attributes' do
        let(:action) { :foo }

        it 'does not update the preference and redirects to the movies index' do
          subject

          vote.reload
          expect(vote.action).not_to eq(:foo)
          expect(response).to redirect_to(movies_path)
        end
      end
    end

    it_behaves_like 'actions without permission'
  end

  describe 'DELETE destroy' do
    let(:user) { FactoryBot.create(:user) }
    let(:movie) { FactoryBot.create(:movie) }
    let!(:vote) { FactoryBot.create(:vote, user: user, movie: movie) }

    subject { delete :destroy, params: { id: vote.id, movie_id: movie.id } }

    context 'when user is authenticated' do
      before { sign_in user }

      it 'deletes the vote and redirects to the movies index with a success notice' do
        expect { subject }.to change(Vote, :count).by(-1)

        expect(response).to redirect_to(movies_path)
        expect(flash[:notice]).to eq('You removed your vote!')
      end
    end

    it_behaves_like 'actions without permission'
  end
end

class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_action, only: [ :create, :update ]
  before_action :set_movie, only: [ :create, :update, :destroy ]
  before_action :check_user_is_not_uploader
  before_action :set_vote, only: [ :update, :destroy ]

  def create
    @vote = Vote.new(user: current_user, movie: @movie, action: @action)

    if @vote.save
      respond_to do |format|
        format.html { redirect_to movies_path, notice: "Thanks for voting!" }
        format.turbo_stream do
          flash.now[:notice] = "Thanks for voting!"
          render turbo_stream: [
                   turbo_stream.replace("movie_#{@movie.id}",
                                        partial: "movies/movie_preference_actions",
                                        locals: {
                                          movie: @movie,
                                          like_count: @movie.likes.count,
                                          hate_count: @movie.hates.count,
                                          vote: @vote
                                        }),
                   turbo_stream.replace("flash", partial: "shared/notices")
                 ]
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to movies_path, alert: @vote.errors.full_messages.join("<br>").html_safe }
        format.turbo_stream { flash.now[:alert] = @vote.errors.full_messages.join("<br>").html_safe }
      end
    end
  end

  def update
    if @vote.update(action: @action)
      respond_to do |format|
        format.html { redirect_to movies_path, notice: "Your vote has changed!" }
        format.turbo_stream do
          flash.now[:notice] = "Thanks for voting!"
          render turbo_stream: [
                   turbo_stream.replace("movie_#{@movie.id}",
                                        partial: "movies/movie_preference_actions",
                                        locals: {
                                          movie: @movie,
                                          like_count: @movie.likes.count,
                                          hate_count: @movie.hates.count,
                                          vote: @vote
                                        }),
                   turbo_stream.replace("flash", partial: "shared/notices")
                 ]
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to movies_path, alert: @vote.errors.full_messages.join("<br>").html_safe }
        format.turbo_stream { flash.now[:alert] = @vote.errors.full_messages.join("<br>").html_safe }
      end
    end
  end

  def destroy
    @vote.destroy
    respond_to do |format|
      format.html { redirect_to movies_path, notice: "You removed your vote!" }
      format.turbo_stream do
        flash.now[:notice] = "You removed your vote!"
        render turbo_stream: [
                 turbo_stream.replace("movie_#{@movie.id}",
                                      partial: "movies/movie_preference_actions",
                                      locals: {
                                        movie: @movie,
                                        like_count: @movie.likes.count,
                                        hate_count: @movie.hates.count,
                                        vote: nil
                                      }),
                 turbo_stream.replace("flash", partial: "shared/notices")
               ]
      end
    end
  end

  private

  def set_action
    @action = params[:user_action]&.to_sym

    redirect_to movies_path, alert: "No such action exists" unless Vote.actions.include?(@action)
  end

  def set_movie
    @movie = Movie.find_by(id: params[:movie_id])

    redirect_to movies_path, alert: "No such movie exists" unless @movie.present?
  end

  def set_vote
    @vote = Vote.find_by(id: params[:id], user: current_user)

    redirect_to movies_path, alert: "You have not voted the movie yet" unless @vote.present?
  end

  def check_user_is_not_uploader
    redirect_to movies_path, alert: "You cannot vote your own movie" if @movie.user == current_user
  end
end

class UserMoviePreferencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_action, only: [ :create, :update ]
  before_action :set_movie, only: [ :create, :update, :destroy ]
  before_action :set_user_movie_preference, only: [ :update, :destroy ]

  def create
    @user_movie_preference = UserMoviePreference.new(user: current_user, movie: @movie, action: @action)

    if @user_movie_preference.save
      redirect_to movies_path, notice: "Thanks for voting!"
    else
      redirect_to movies_path, alert: @user_movie_preference.errors.full_messages.join("<br>").html_safe
    end
  end

  def update
    if @user_movie_preference.update(action: @action)
      redirect_to movies_path, notice: "Your vote has changed!"
    else
      redirect_to edit_movie_path, alert: @movie.errors.full_messages.join("<br>").html_safe
    end
  end

  def destroy
    @user_movie_preference.destroy
    redirect_to movies_path, notice: "You removed your vote!"
  end

  private

  def set_action
    @action = params[:user_action]&.to_sym

    redirect_to movies_path, alert: "No such action exists" unless UserMoviePreference.actions.include?(@action)
  end

  def set_movie
    @movie = Movie.find_by(id: params[:movie_id])

    redirect_to movies_path, alert: "No such movie exists" unless @movie.present?
  end

  def set_user_movie_preference
    @user_movie_preference = UserMoviePreference.find_by(id: params[:id], user: current_user)

    redirect_to movies_path, alert: "You have not voted the movie yet" unless @user_movie_preference.present?
  end
end

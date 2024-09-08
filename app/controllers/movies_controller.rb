class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_movie, only: [ :edit, :update, :destroy ]

  def index
    if params[:filter] == "date"
      @movies = Movie.includes(:user).order(created_at: :desc)
    elsif params[:filter] == "user"
      user = User.find_by(id: params[:user_id])

      if user.present?
        @movies = user.movies
      else
        redirect_to movies_path, notice: "User not found"
      end
    else
      @movies = Movie.includes(:user).order(id: :desc)
    end

    @movies = @movies.paginate(page: params[:page], per_page: 10)
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params.merge(user: current_user))

    if @movie.save
      redirect_to movies_path, notice: "Movie was successfully created."
    else
      redirect_to new_movie_path, alert: @movie.errors.full_messages.join("<br>").html_safe
    end
  end

  def edit
  end

  def update
    if @movie.update(movie_params)
      redirect_to movies_path, notice: "Movie was successfully updated."
    else
      redirect_to edit_movie_path, alert: @movie.errors.full_messages.join("<br>").html_safe
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_path, notice: "Movie was successfully destroyed."
  end

  private

  def set_movie
    @movie = Movie.find_by(id: params[:id], user: current_user)

    redirect_to movies_path, notice: "You are not allowed to edit that movie" unless @movie.present?
  end

  def movie_params
    params.require(:movie).permit([ :title, :description ])
  end
end

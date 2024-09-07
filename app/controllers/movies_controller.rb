class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_movie, only: [ :edit, :update, :destroy ]

  def index
    @movies = Movie.all
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
    @movie = Movie.find(params[:id])
  end

  def movie_params
    params.require(:movie).permit([ :title, :description ])
  end
end

class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_movie, only: [ :edit, :update, :destroy ]
  before_action :set_user, only: [ :index ]
  before_action :permit_params

  def index
    @movies = @user.present? ? @user.movies : Movie.all

    if params[:sort_by] == "date"
      @movies = @movies.order(created_at: :desc)
    elsif params[:sort_by] == "likes"
      @movies = @movies.order_by_likes
    elsif params[:sort_by] == "hates"
      @movies = @movies.order_by_hates
    else
      @movies = @movies.order(id: :desc)
    end

    @movies = @movies.includes(:user, :hates, :likes).
                      paginate(page: params[:page], per_page: 10)

    @votes = current_user&.votes&.where(movie: @movies)&.index_by(&:movie_id)

    @like_count = Vote.where(movie: @movies, action: :like).group(:movie_id).count
    @hate_count = Vote.where(movie: @movies, action: :hate).group(:movie_id).count
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
      redirect_to movies_path(@params.merge(page: params[:page])), notice: "Movie was successfully updated."
    else
      redirect_to edit_movie_path(@movie, @params.merge(page: params[:page])), alert: @movie.errors.full_messages.join("<br>").html_safe
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_path(@params.merge(page: params[:page])), notice: "Movie was successfully destroyed."
  end

  private

  def set_movie
    @movie = Movie.find_by(id: params[:id], user: current_user)

    redirect_to movies_path, notice: "You are not allowed to edit that movie" unless @movie.present?
  end

  def movie_params
    params.require(:movie).permit([ :title, :description ])
  end

  def set_user
    return unless params[:user_id]

    @user = User.find_by(id: params[:user_id])

    redirect_to movies_path, notice: "User not found" unless @user.present?
  end

  def permit_params
    @params = params.permit(:sort_by, :user_id)
  end
end

module MoviesHelper
  def relevant_preferences_link(movie, user_movie_preference, message, action)
    if user_movie_preference.present?
      if user_movie_preference.action.to_sym == action
        message
      else
        link_to message,
                user_movie_preference_path(id: user_movie_preference.id, movie_id: movie.id, user_action: action),
                data: { turbo_method: :put }
      end
    else
      link_to message,
              user_movie_preferences_path(movie_id: movie.id, user_action: action),
              data: { turbo_method: :post }
    end
  end

  def hide_preference_actions?(movie)
    movie.user == current_user
  end
end

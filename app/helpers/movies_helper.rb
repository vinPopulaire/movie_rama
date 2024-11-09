module MoviesHelper
  def relevant_preferences_link(movie, vote, message, action)
    if vote.present?
      if vote.action.to_sym == action
        message
      else
        link_to message,
                vote_path(id: vote.id, movie_id: movie.id, user_action: action),
                data: { turbo_method: :put }
      end
    else
      link_to message,
              votes_path(movie_id: movie.id, user_action: action),
              data: { turbo_method: :post }
    end
  end

  def hide_preference_actions?(movie)
    movie.user == current_user
  end
end

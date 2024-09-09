module MoviesHelper
  def relevant_preferences_like_link(movie, user_movie_preferences)
    if (preference = user_movie_preferences[movie.id]).present?
      if preference.action == "like"
        movie.like_count.to_s + " likes"
      else
        link_to movie.like_count.to_s + " likes",
                user_movie_preference_path(id: preference.id, movie_id: movie.id, user_action: :like),
                data: { turbo_method: :put }
      end
    else
      link_to movie.like_count.to_s + " likes",
              user_movie_preferences_path(movie_id: movie.id, user_action: :like),
              data: { turbo_method: :post }
    end
  end

  def relevant_preferences_hate_link(movie, user_movie_preferences)
    if (preference = user_movie_preferences[movie.id]).present?
      if preference.action == "hate"
        movie.hate_count.to_s + " hates"
      else
        link_to movie.hate_count.to_s + " hates",
                user_movie_preference_path(id: preference.id, movie_id: movie.id, user_action: :hate),
                data: { turbo_method: :put }
      end
    else
      link_to movie.hate_count.to_s + " hates",
              user_movie_preferences_path(movie_id: movie.id, user_action: :hate),
              data: { turbo_method: :post }
    end
  end

  def hide_preference_actions?(movie)
    movie.user == current_user
  end
end

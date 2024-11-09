class ChangeUserMoviePreferenceToVote < ActiveRecord::Migration[7.2]
  def change
    rename_table :user_movie_preferences, :votes
  end
end

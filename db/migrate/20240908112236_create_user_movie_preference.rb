class CreateUserMoviePreference < ActiveRecord::Migration[7.2]
  def change
    create_table :user_movie_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.integer :action, null: false, limit: 1

      t.timestamps

      t.index [ :movie_id, :action ], name: "index_preference_on_movie_id_action"
      t.index [ :user_id, :movie_id ], name: "index_preference_on_user_id_movie_id", unique: true
    end
  end
end

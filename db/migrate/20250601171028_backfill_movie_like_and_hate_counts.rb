class BackfillMovieLikeAndHateCounts < ActiveRecord::Migration[7.2]
  def up
    execute <<-SQL.squish
      WITH votes_cte AS(
        SELECT movie_id, COUNT(*) AS cnt
        FROM votes
        WHERE action = #{Vote.actions[:like]}
        GROUP BY movie_id
      )
      UPDATE movies
      SET like_count = votes_cte.cnt
      FROM votes_cte
      WHERE movies.id = votes_cte.movie_id
    SQL

    execute <<-SQL.squish
      WITH votes_cte AS(
        SELECT movie_id, COUNT(*) AS cnt
        FROM votes
        WHERE action = #{Vote.actions[:hate]}
        GROUP BY movie_id
      )
      UPDATE movies
      SET hate_count = votes_cte.cnt
      FROM votes_cte
      WHERE movies.id = votes_cte.movie_id
    SQL
  end

  def down
    Movie.update_all(like_count: 0, hate_count: 0)
  end
end

class AddLikeAndHateCountToMovieTable < ActiveRecord::Migration[7.2]
  def change
    change_table :movies do |t|
      t.integer :like_count, default: 0, null: false
      t.integer :hate_count, default: 0, null: false
    end
  end
end

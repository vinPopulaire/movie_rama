class AddUserRelationToMovie < ActiveRecord::Migration[7.2]
  def change
    add_reference :movies, :user, type: :integer, null: false
  end
end

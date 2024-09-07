class AddNameAndSurnameToUsers < ActiveRecord::Migration[7.2]
  def change
    change_table :users do |t|
      t.string :name, null: false
      t.string :surname, null: false
    end
  end
end

class CreateFavourites < ActiveRecord::Migration[6.0]
  def change
    create_table :favourites do |t|
      t.references :property, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end

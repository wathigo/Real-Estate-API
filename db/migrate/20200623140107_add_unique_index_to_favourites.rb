class AddUniqueIndexToFavourites < ActiveRecord::Migration[6.0]
  def change
    add_index :favourites, [:user_id, :property_id], unique: true
  end
end

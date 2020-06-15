class CreateGeoLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :geo_locations do |t|
      t.references :property, foreign_key: true
      t.float :latt
      t.float :long

      t.timestamps
    end
  end
end

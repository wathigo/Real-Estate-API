class CreateProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :properties do |t|
      t.references :category, foreign_key: true
      t.string :address
      t.string :status, :default => 'available'
      t.string :description
      t.integer :price

      t.timestamps
    end
  end
end

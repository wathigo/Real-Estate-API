class Property < ApplicationRecord
  belongs_to :category
  has_one :geo_location, dependent: :destroy
  has_many :favourites, dependent: :destroy

  validates_presence_of :address, :description, :status, :price
end

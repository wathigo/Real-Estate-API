class Property < ApplicationRecord
  belongs_to :category
  has_one :geo_location

  validates_presence_of :address, :description, :status, :price
end

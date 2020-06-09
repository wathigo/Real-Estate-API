class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :property

  validates_presence_of :user_id, :property_id
end

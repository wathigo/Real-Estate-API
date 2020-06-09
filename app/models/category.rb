class Category < ApplicationRecord
  has_many :properties

  validates_presence_of :name
end

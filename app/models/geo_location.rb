class GeoLocation < ApplicationRecord
    belongs_to :property

    validates_presence_of :latt, :long
end

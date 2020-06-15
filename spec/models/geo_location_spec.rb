require 'rails_helper'

RSpec.describe GeoLocation, type: :model do
  it { should belong_to(:property) }

  it { should validate_presence_of(:latt) }
  it { should validate_presence_of(:long) }
end

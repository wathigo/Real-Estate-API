require 'rails_helper'

RSpec.describe Property, type: :model do
  it { should have_many(:favourites).dependent(:destroy) }
  it { should have_one(:geo_location).dependent(:destroy) }

  it { should belong_to(:category) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }
end

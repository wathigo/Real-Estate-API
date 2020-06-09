require 'rails_helper'

RSpec.describe Favourite, type: :model do
  it { should belong_to(:property) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:property_id) }
end

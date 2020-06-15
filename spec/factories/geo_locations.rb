FactoryBot.define do
  factory :geo_location do
    latt { Faker::Address.latitude }
    long { Faker::Address.longitude }
    association :property
  end
end

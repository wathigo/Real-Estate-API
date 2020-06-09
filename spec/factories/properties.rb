FactoryBot.define do
  factory :property do
    address { Faker::Address.full_address }
    price { Faker::Number.number(digits: 10) }
    description { Faker::Lorem.paragraph(sentence_count: 30) }
    association :geo_location
    association :category
  end
end

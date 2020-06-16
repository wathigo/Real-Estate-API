# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

categories = ['Housing Properties', 'Land Properties']
categories.each do |n|
  Category.create!(name: n)
end

categories = Category.all

all_status = ['booked', 'reserved', 'bought', 'Available']

categories.each do |category|
    8.times do |n|
      category.properties.create!(
        address: Faker::Address.full_address,
        description: Faker::Lorem.paragraph(sentence_count: 30),
        price: (200000 + rand(1000000)),
        status: all_status.sample
      )
    end
end

properties = Property.all 

properties.each do |property|
GeoLocation.create(property_id: property.id, latt: Faker::Address.latitude, long: Faker::Address.longitude)
end
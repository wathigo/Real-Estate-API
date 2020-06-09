# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { 'foobar@help.com' }
    password { 'foobar' }
  end
end

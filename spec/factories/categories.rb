# frozen_string_literal: true

FactoryBot.define do
    factory :category do
      name { Faker::Name.name }
      association :property
    end
  end
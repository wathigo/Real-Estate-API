# frozen_string_literal: true

FactoryBot.define do
    factory :category do
      name { Faker::Name.name }
    end
  end
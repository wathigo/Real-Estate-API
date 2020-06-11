FactoryBot.define do
  factory :favourite do
    association :user
    association :property
  end
end

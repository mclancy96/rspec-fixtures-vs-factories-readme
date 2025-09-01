FactoryBot.define do
  factory :volunteer do
    sequence(:name) { |n| "Volunteer#{n}" }
    association :organization
  end
end

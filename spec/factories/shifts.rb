FactoryBot.define do
  factory :shift do
    starts_at { 1.day.from_now }
    ends_at { 2.days.from_now }
    association :organization
  end
end

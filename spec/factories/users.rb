FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "name #{n}" }
  end
end

FactoryBot.define do
  factory :sleep_record do
    went_to_bed_at { "2025-08-08 00:18:32" }
    woke_up_at { "2025-08-08 00:18:32" }
  end

  trait :with_to_bed_at_a_week_ago_random do
    went_to_bed_at { 1.week.ago.beginning_of_day + 20.hours + rand(3).hours }
  end

  trait :with_to_bed_at_a_week_ago do
    went_to_bed_at { 1.week.ago.beginning_of_day }
  end
end

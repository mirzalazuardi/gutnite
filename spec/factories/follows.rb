FactoryBot.define do
  factory :follow do
    follower { User.first }
  end

  trait :with_follower_first do
    follower { User.first || create(:user) }
  end

  trait :with_follower_last do
    follower { User.last }
  end

  trait :with_followed_first do
    followed_user { User.first || create(:user) }
  end

  trait :with_followed_last do
    followed_user { User.last }
  end
end

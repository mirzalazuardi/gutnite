# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
time = 1.week.ago.beginning_of_day

10.times do |i|
  u = User.find_or_create_by!(name: Faker::Name.name + " #{i+1}")
end

User.all.each do |user|
  (User.ids.sample(5) - [user.id]).each do |follower_id|
    followed = User.find(follower_id)
    FollowUserService.call(user, followed)
  end
end

User.all.each do |user|
  10.times do |i|
    SleepRecord.create!(
      user: user,
      went_to_bed_at: time + (rand(3) + 20).hours + i.days,
      woke_up_at: time + (rand(5) + 24).hours + i.days,
    )
  end
end

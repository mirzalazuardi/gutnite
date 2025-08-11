class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed_user, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :followed_user_id, message: "You are already following this user" }
  validates :followed_user_id, presence: true
  validates :follower_id, presence: true

  # Additional validations or methods can be added here if needed
end

class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed_user, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :followed_user_id, message: "You are already following this user" }
  validates :followed_user_id, presence: true
  validates :follower_id, presence: true
  validate :cannot_follow_self

  def cannot_follow_self
    errors.add(:followed_user_id, "You cannot follow yourself") if follower_id == followed_user_id
  end
end

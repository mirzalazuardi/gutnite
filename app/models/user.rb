class User < ApplicationRecord
  has_many :follows, foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :follows, source: :followed_user

  has_many :inverse_follows, class_name: 'Follow', foreign_key: :followed_user_id, dependent: :destroy
  has_many :followers, through: :inverse_follows, source: :follower

  validates :name, presence: true, uniqueness: true
end

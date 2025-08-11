class FollowSerializer
  include Alba::Resource
  attributes :id, :follower_id, :followed_user_id, :created_at
  attribute :follower_name do |object|
    object.follower.name
  end
  attribute :followe_user_name do |object|
    object.followed_user.name
  end
end

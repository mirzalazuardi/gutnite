class FollowSerializer
  include Alba::Resource
  attributes :id, :follower_id, :followed_id, :created_at
end

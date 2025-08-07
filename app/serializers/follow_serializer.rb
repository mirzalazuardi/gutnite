class FollowSerializer < ActiveModel::Serializer
  attributes :id, :follower_id, :followed_id, :created_at
end

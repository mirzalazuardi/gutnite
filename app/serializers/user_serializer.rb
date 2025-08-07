class UserSerializer < ActiveModel::Serializer
  include Alba::Resource
  attributes :id, :name
end

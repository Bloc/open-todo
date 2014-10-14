class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :permissions
end

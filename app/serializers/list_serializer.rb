class ListSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :permissions
  has_many :items
end

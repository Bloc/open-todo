class ListSerializer < ActiveModel::Serializer
  attributes :name, :user_id, :permissions

end

class ItemSerializer < ActiveModel::Serializer
  attributes :id, :description, :completed
end

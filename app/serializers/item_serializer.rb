class ItemSerializer < ActiveModel::Serializer
  attributes :list_id, :description, :completed
end

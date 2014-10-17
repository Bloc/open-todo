class ListSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :permissions
  has_many :items

  def items
    object.items.completed
  end
end

# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  list_id     :integer
#  description :string
#  completed   :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

class ItemSerializer < ActiveModel::Serializer
  attributes :id, :list_id, :description, :completed, :created_at, :updated_at
end

# == Schema Information
#
# Table name: lists
#
#  id          :integer          not null, primary key
#  name        :string
#  user_id     :integer
#  permissions :string           default("private")
#  created_at  :datetime
#  updated_at  :datetime
#

class ListSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :permissions, :created_at, :updated_at
end

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string
#  password   :string
#  created_at :datetime
#  updated_at :datetime
#

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :password, :created_at, :updated_at
end

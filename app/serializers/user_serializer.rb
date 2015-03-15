# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string
#

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username
end

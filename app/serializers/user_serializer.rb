class UserSerializer < ActiveModel::Serializer
  attributes :username, :password
  def username
    object.username
  end

end

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username

  def username
    object.username
  end

  def created_at
    object.created_at.strftime('%B %d, %Y')
  end

  def updated_at
    object.updated_at.strftime('%B %d, %Y')
  end
end

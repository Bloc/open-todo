class UserSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :username

  # Delegate the practical definition of `full_name` to
  # the User model, where it belongs, rather than
  # (re)defining it here.
  def username
    object.username
  end

  def created_at
    object.created_at.strftime('%B %d, %Y')
  end
end


class InsecureUserSerializer < ActiveModel::Serializer
  attributes :id, :password, :username

  def username
    object.username
  end
end

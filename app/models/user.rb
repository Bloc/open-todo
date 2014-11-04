class User < ActiveRecord::Base
  has_many :lists
  has_many :items, through: :lists
  attr_accessor :password
  before_save :encrypt_password

  validates_presence_of :password, :email
  validates_uniqueness_of :email

  def authenticate?(pass)
    password == pass
  end

  def can?(action, list)
    case list.permissions
    when 'private'  then owns?(list)
    when 'visible'  then action == :view
    when 'open' then true
    else false
    end
  end

  def encrypt_password  # Can I make this a private method?
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  private

  def owns?(list)
    list.user_id == id
  end
end

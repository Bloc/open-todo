class User < ActiveRecord::Base
  has_one :api_keys, dependent: :destroy
  has_many :lists
  has_many :items, through: :lists

  validates_presence_of :password, :username

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

  after_create :create_api_key

  private

  def owns?(list)
    list.user_id == id
  end

  def create_api_key
    ApiKey.create user: self
  end
end

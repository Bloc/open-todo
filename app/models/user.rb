class User < ActiveRecord::Base
  has_one :api_key, dependent: :destroy
  has_many :lists, dependent: :destroy
  has_many :items, through: :lists

  validates_presence_of :password, :username
  validates_uniqueness_of :username

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

class ListSerializer < ActiveModel::ListSerializer

  attributes :name
  belongs_to :user
  has_many :items

  url [:user, :list]

end
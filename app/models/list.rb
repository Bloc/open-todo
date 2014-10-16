class List < ActiveRecord::Base
  belongs_to :user
  has_many :items

  validates_presence_of :name, :permissions
  validates_inclusion_of :permissions, in: %w(private viewable open)
  validates_uniqueness_of :name

  scope :owner, -> (user) { where(user_id: user.id)}
  scope :not_private, -> { where.not(permissions: "private") }

  def self.permission_options
    %w(private viewable open)
  end

  def add(item_description)
    if items.create(description: item_description)
      true
    else
      false
    end
  end

  def remove(item_description)
    if item = items.find_by(description: item_description)
      item.mark_complete
    else
      false
    end
  end
end

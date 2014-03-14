class Item < ActiveRecord::Base
  belongs_to :list
  delegate :user, to: :list

  scope :completed, -> { where(completed: false) }

  def mark_complete
    update_attribute(:completed, true)
  end
end

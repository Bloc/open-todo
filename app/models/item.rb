# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  list_id     :integer
#  description :string
#  completed   :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Item < ActiveRecord::Base
  belongs_to :list
  delegate :user, to: :list

  scope :completed, -> { where(completed: false) }

  def mark_complete
    update_attribute(:completed, true)
  end
end

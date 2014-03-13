class Item < ActiveRecord::Base
  belongs_to :list

  def mark_complete
    update_attribute(:completed, true)
  end
end

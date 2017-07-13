# == Schema Information
#
# Table name: notices
#
#  id         :integer          not null, primary key
#  message    :text(65535)      not null
#  active     :boolean          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notice < ApplicationRecord
  
  before_validation :allow_one_active, on: :create
  
  def self.active
    find_by active: true
  end
  
  def allow_one_active  
    if self.active && Notice.where(active: true).count > 0
      self.errors.add(:base, "can't have more than one active notice") 
    end 
  end
  
end

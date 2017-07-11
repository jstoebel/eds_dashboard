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
  
  before_validation :allow_one_active
  
  def self.latest
    order(:created_at).last
  end
  
  def allow_one_active
    if Notice.where(active: true).count > 1
      self.errors.add(:base, "can't have more than one active notice") 
    end
  end
  
end

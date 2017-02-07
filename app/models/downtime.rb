# == Schema Information
#
# Table name: downtimes
#
#  id         :integer          not null, primary key
#  start_time :datetime
#  end_time   :datetime
#  reason     :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Downtime < ActiveRecord::Base

  validates_presence_of :start_time, :end_time, :reason

  scope :future, lambda {where("start_time > ?", DateTime.now)}

end

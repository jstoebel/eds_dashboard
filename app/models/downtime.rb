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
#  active     :boolean
#

class Downtime < ActiveRecord::Base

    after_initialize :init

    validates_presence_of :start_time, :end_time, :reason

    scope :future, lambda {where("start_time < ?", DateTimen.now)}
    scope :active, lambda {where(:active => true)}

    def self.has_impending?
        # are there any active downtimes scheduled to start in the past?

        return Downtime.all
            .where({:active => true})
            .where("start_time < ?", DateTime.now)
            .size > 0
    end

    def init
        self.active = true
    end

    def time_range
        return "#{self.start_time.strftime('%c')} and #{self.end_time.strftime('%c')}"
    end


end

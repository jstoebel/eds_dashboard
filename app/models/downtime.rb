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
    before_save :fix_times

    validates_presence_of :start_time, :end_time, :reason

    scope :future, lambda {where("start_time < ?", DateTimen.now)}
    scope :active, lambda {where(:active => true)}

    def self.has_impending?
        # are there any active downtimes scheduled to start in the past?

        return Downtime.all
            .where({:active => true})
            .where("start_time < ?", DateTime.now)  # anything scheduled to start in the past?
            .size > 0
    end

    def init
        # set defaults for new record
        self.active = true if self.new_record?
    end

    def fix_times
      # if the start or end time was changed, parse the time as being in EST
      # if self.send(:start_time_changed?) do
      #     new_time = ActiveSupport::TimeZone.new('America/New_York').local_to_utc(self.send(:start_time))
      #     self.send(:"#{start_time}=", new_time)
      # end

      [:start_time, :end_time].each do |attr|

        if self.send("#{attr}_changed?")
          new_time = ActiveSupport::TimeZone.new('America/New_York').local_to_utc(self.send(attr))
          self.send("#{attr}=", new_time)
        end
      end
    end

    def time_range
        return "#{self.start_time.strftime('%c')} and #{self.end_time.strftime('%c')}"
    end


end

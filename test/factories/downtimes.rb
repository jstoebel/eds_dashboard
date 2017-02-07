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

include Faker
FactoryGirl.define do
  factory :downtime do
      start_time {Date.today}
      end_time {Date.today}
      reason {Lorem.sentence}
      active true

  end
end

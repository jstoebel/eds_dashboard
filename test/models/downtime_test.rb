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

require 'test_helper'

class DowntimeTest < ActiveSupport::TestCase
    tz = TZInfo::Timezone.get('America/New_York')
    current_tz_info = tz.current_period
    current_offset = current_tz_info.utc_total_offset # seconds offset from utc (accounting for DST)

    describe "validate_presence_of" do

        before do
            @dt = Downtime.new
            @dt.valid?
        end

        [:start_time, :end_time, :reason].each do |attr|
            test "validates #{attr}" do
                assert_equal ["can't be blank"], @dt.errors[attr]
            end
        end

    end # validate presence of

    test "has_impending" do
        dt = FactoryGirl.create :downtime, {
            :start_time => 2.days.ago,
            :end_time => 1.day.ago
        }

        assert Downtime.has_impending?
    end

    test "init" do
        dt = Downtime.new
        assert dt.active
    end

    test "time_range" do
        dt = FactoryGirl.create :downtime

        assert_equal "#{dt.start_time.strftime('%c')} and #{dt.end_time.strftime('%c')}", dt.time_range
    end

    describe "fix_time" do

      [:start_time, :end_time].each do |attr|

        describe "for #{attr}" do

          test "alters time if attr changed" do
            dt = FactoryGirl.build :downtime
            before_save = dt.send(attr)
            dt.save
            assert_equal current_offset, before_save - dt.send(attr)

          end

          test "does not alter time if attr not changed" do
            dt = FactoryGirl.create :downtime
            before_save = dt.send(attr)
            dt.save
            assert_equal 0, before_save - dt.send(attr)
          end

        end

      end

    end
end

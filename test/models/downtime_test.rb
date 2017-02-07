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

require 'test_helper'

class DowntimeTest < ActiveSupport::TestCase

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

  end
end

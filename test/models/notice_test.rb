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

require 'test_helper'

class NoticeTest < ActiveSupport::TestCase
  
  test "latest" do
    notices = (1..2).map{|i| FactoryGirl.create :notice, {:created_at => i.days.ago,
        :active => false
      }
    }
    assert_equal Notice.latest, notices.last
  end
  
  test "allow_one_active" do
    n1 = FactoryGirl.create :notice
    assert_raises 
  end
  
end

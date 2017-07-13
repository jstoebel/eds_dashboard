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
    notices = [false, true].map{|state| FactoryGirl.create :notice, 
      {:active => state}
    }
    assert_equal Notice.active, notices.last
  end
  
  test "latest return nil if no active notices" do
    notice = FactoryGirl.create :notice, active: false
    
    assert_nil Notice.active
  end
  
  test "allow_one_active" do
    n1 = FactoryGirl.create :notice
    assert_raises ActiveRecord::RecordInvalid do 
      FactoryGirl.create :notice
    end
  end
  
end

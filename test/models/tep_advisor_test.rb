# == Schema Information
#
# Table name: tep_advisors
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  AdvisorBnum :string(9)        not null
#  Salutation  :string(255)
#  user_id     :integer
#

require 'test_helper'

class TepAdvisorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

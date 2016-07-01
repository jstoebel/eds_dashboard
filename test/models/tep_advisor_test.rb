# == Schema Information
#
# Table name: tep_advisors
#
#  id          :integer          not null, primary key
#  AdvisorBnum :string(9)        not null
#  name        :string(255)
#  Salutation  :string(255)
#  user_id     :integer
#

require 'test_helper'

class TepAdvisorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

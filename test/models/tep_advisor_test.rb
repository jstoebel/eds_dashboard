# == Schema Information
#
# Table name: tep_advisors
#
#  id          :integer          not null, primary key
#  AdvisorBnum :string(9)        not null
#  Salutation  :string(45)       not null
#  user_id     :integer
#  first_name  :string(255)      not null
#  last_name   :string(255)      not null
#

require 'test_helper'

class TepAdvisorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: employment
#
#  EmpID       :integer          not null, primary key
#  student_id  :integer          not null
#  EmpDate     :date             not null
#  EmpCategory :string(45)
#  Employer    :string(45)
#

require 'test_helper'

class EmploymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

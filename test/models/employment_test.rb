# == Schema Information
#
# Table name: employment
#
#  student_id  :integer          not null
#  EmpID       :integer          not null, primary key
#  EmpDate     :date             not null
#  EmpCategory :string(45)
#  Employer    :string(45)
#
# Indexes
#
#  employment_student_id_fk  (student_id)
#

require 'test_helper'

class EmploymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

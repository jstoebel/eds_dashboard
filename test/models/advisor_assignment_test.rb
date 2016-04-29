# == Schema Information
#
# Table name: advisor_assignments
#
#  id             :integer          not null, primary key
#  student_id     :integer          not null
#  tep_advisor_id :integer          not null
#
# Indexes
#
#  advisor_assignments_tep_advisor_id_fk                       (tep_advisor_id)
#  index_advisor_assignments_on_student_id_and_tep_advisor_id  (student_id,tep_advisor_id) UNIQUE
#

require 'test_helper'

class AdvisorAssignmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

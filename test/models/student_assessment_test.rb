# == Schema Information
#
# Table name: student_assessments
#
#  id                    :integer          not null, primary key
#  student_id            :integer          not null
#  assessment_version_id :integer          not null
#  created_at            :datetime
#  updated_at            :datetime
#
# Indexes
#
#  student_assessments_assessment_version_id_fk  (assessment_version_id)
#  student_assessments_student_id_fk             (student_id)
#

require 'test_helper'

class StudentAssessmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student_assessment do
  end
end

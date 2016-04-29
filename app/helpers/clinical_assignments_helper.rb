# == Schema Information
#
# Table name: clinical_assignments
#
#  student_id          :integer          not null
#  id                  :integer          not null, primary key
#  clinical_teacher_id :integer          not null
#  Term                :integer          not null
#  CourseID            :string(45)       not null
#  Level               :string(45)
#  StartDate           :date
#  EndDate             :date
#

module ClinicalAssignmentsHelper
end

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
# Indexes
#
#  clinical_assignments_student_id_fk           (student_id)
#  fk_ClinicalAssignments_ClinicalTeacher1_idx  (clinical_teacher_id)
#

module ClinicalAssignmentsHelper
end

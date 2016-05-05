# == Schema Information
#
# Table name: clinical_assignments
#
#  id                  :integer          not null, primary key
#  student_id          :integer          not null
#  clinical_teacher_id :integer          not null
#  Term                :integer          not null
#  CourseID            :string(45)       not null
#  Level               :string(45)
#  StartDate           :date
#  EndDate             :date
#

FactoryGirl.define do
  factory :clinical_assignment do

  end
end

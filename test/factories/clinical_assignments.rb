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
include Faker
FactoryGirl.define do
  factory :clinical_assignment do
    student
    clinical_teacher
    #banner_term must be supplied
    CourseID {Lorem.characters 6}
    Level {Faker::Number.between(1,3)}

    #start and end date dependant on banner_term, and thus must also be supplied
  end
end

# == Schema Information
#
# Table name: advisor_assignments
#
#  id             :integer          not null, primary key
#  student_id     :integer          not null
#  tep_advisor_id :integer          not null
#

FactoryGirl.define do
    factory :advisor_assignment do
        association :student, factory: :student
        association :tep_advisor, factory: :tep_advisor
    end 
end

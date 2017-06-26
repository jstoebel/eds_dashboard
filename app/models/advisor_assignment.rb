# == Schema Information
#
# Table name: advisor_assignments
#
#  id             :integer          not null, primary key
#  student_id     :integer          not null
#  tep_advisor_id :integer          not null
#


# represents a single assignment of a student with an advisor
class AdvisorAssignment < ApplicationRecord
	belongs_to :student
	belongs_to :tep_advisor
end

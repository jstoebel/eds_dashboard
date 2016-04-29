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

require 'test_helper'

class ClinicalAssignmentTest < ActiveSupport::TestCase

	test "no teacher id" do
		assignment = ClinicalAssignment.first
		assignment.clinical_teacher_id = nil
		assignment.valid?
		py_assert(["Please select a clinical teacher."], assignment.errors[:clinical_teacher_id])	
	end

	test "unique assignment catch" do
		assignment = ClinicalAssignment.first
		assignment2 = assignment.clone
		assignment2.id = nil
		assignment2.valid?
		py_assert(["Student may not be matched with same teacher more than once in the same course in the same semester."], assignment2.errors[:clinical_teacher_id])
	end

	test "unique assignment pass" do
		assignment = ClinicalAssignment.first
		assignment2 = ClinicalAssignment.new(assignment.attributes)
		assignment2.CourseID = "EDS335"		#a differing course should allow this to pass
		assignment2.valid?
		py_assert([], assignment2.errors[:clinical_teacher_id])

	end

	test "need bnum" do
		assignment = ClinicalAssignment.first
		assignment.student_id = nil
		assignment.valid?
		py_assert(["Please select a student."], assignment.errors[:student_id])

	end

	test "need start date" do
		assignment = ClinicalAssignment.first
		assignment.StartDate = nil
		assignment.valid?
		py_assert(["Please enter a valid start date."], assignment.errors[:StartDate])
	end

	test "need end date" do
		assignment = ClinicalAssignment.first
		assignment.EndDate = nil
		assignment.valid?
		py_assert(["Please enter a valid end date."], assignment.errors[:EndDate])
	end

	test "start before end" do
		assignment = ClinicalAssignment.first
		#swap start and end dates
		new_start = assignment.EndDate
		new_end = assignment.StartDate
		assignment.StartDate = new_start
		assignment.EndDate = new_end
		assignment.valid?
		py_assert(["Start date must be before end date."], assignment.errors[:base])
	end
		
end

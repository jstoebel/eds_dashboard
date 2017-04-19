# == Schema Information
#
# Table name: clinical_assignments
#
#  id                  :integer          not null, primary key
#  student_id          :integer          not null
#  clinical_teacher_id :integer          not null
#  Term                :integer          not null
#  Level               :string(45)
#  StartDate           :date
#  EndDate             :date
#  transcript_id       :integer
#

require 'test_helper'

class ClinicalAssignmentTest < ActiveSupport::TestCase

	test "no teacher id" do
		assignment = FactoryGirl.create :clinical_assignment
		assignment.clinical_teacher_id = nil
		assignment.valid?
		assert_equal(["Please select a clinical teacher."], assignment.errors[:clinical_teacher_id])
	end

	test "unique assignment catch" do
    assignment = FactoryGirl.create :clinical_assignment

    assignment2 = FactoryGirl.build :clinical_assignment, {student: assignment.student,
      transcript: assignment.transcript,
      Term: assignment.Term,
      clinical_teacher: assignment.clinical_teacher
    }
    assert_not assignment2.valid?
    assert_equal(["Student may not be matched with same teacher more than once in the same course in the same semester."], assignment2.errors[:clinical_teacher_id])

	end

	test "unique assignment pass" do
		assignment = FactoryGirl.create :clinical_assignment
		assignment2 = ClinicalAssignment.new(assignment.attributes)
		transcript2 = FactoryGirl.create :transcript
		assignment2.transcript_id = transcript2.id		#a differing course should allow this to pass
		assignment2.valid?
		assert_equal([], assignment2.errors[:clinical_teacher_id])

	end

	test "need bnum" do
		assignment = FactoryGirl.create :clinical_assignment
		assignment.student_id = nil
		assignment.valid?
		assert_equal(["Please select a student."], assignment.errors[:student_id])

	end

	test "need start date" do
		assignment = FactoryGirl.create :clinical_assignment
		assignment.StartDate = nil
		assignment.valid?
		assert_equal(["Please enter a valid start date."], assignment.errors[:StartDate])
	end

	test "need end date" do
		assignment = FactoryGirl.create :clinical_assignment
		assignment.EndDate = nil
		assignment.valid?
		assert_equal(["Please enter a valid end date."], assignment.errors[:EndDate])
	end

	test "start before end" do
		assignment = FactoryGirl.create :clinical_assignment
		#swap start and end dates
		new_start = assignment.EndDate
		new_end = assignment.StartDate
		assignment.StartDate = new_start
		assignment.EndDate = new_end
		assignment.valid?
		assert_equal(["Start date must be before end date."], assignment.errors[:base])
	end

	test "need transcript_id" do
		assignment = ClinicalAssignment.new
		assert_not assignment.valid?
		assert_equal ["Course is blank"], assignment.errors[:transcript_id]
	end

end

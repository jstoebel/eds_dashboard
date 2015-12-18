require 'test_helper'

class StudentTest < ActiveSupport::TestCase

	test "by_last scope" do
		
		expected = Student.all.order(LastName: :asc)
		actual = Student.by_last
		py_assert(expected.slice(0, expected.size), actual.slice(0, actual.size))
	end

	test "current scope" do
		#tests the scope called current
		expected = Student.all.where("ProgStatus in (?) and EnrollmentStatus='Active Student'", ['Candidate', 'Prospective'])
		actual = Student.current
		py_assert(expected.slice(0, expected.size), actual.slice(0, actual.size))

	end

	test "candidates scope" do
		expected = Student.all.where("ProgStatus='Candidate' and EnrollmentStatus='Active Student'")
		actual = Student.candidates
		py_assert(expected.slice(0, expected.size), actual.slice(0, actual.size))
	end

	test "from alt_id scope" do
		#pulls a student based on their alt_id.

		s = Student.from_alt_id(2)
		py_assert(s.ProgStatus, "Candidate")		#this student should be the only one with ProgStatus of "Candidate"
	end

	test "is advisee of" do
		assignment = AdvisorAssignment.first
		s = assignment.student
		adv = assignment.tep_advisor
		assert s.is_advisee_of(adv.AdvisorBnum)
	end

	test "is student of" do
		
	end

end

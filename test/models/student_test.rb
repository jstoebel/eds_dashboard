require 'test_helper'

class StudentTest < ActiveSupport::TestCase

	test "by_last scope" do
		
		expected = Student.all.order(LastName: :asc)
		actual = Student.by_last
		assert_equal(expected.slice(0, expected.size), actual.slice(0, actual.size))
	end

	test "current scope" do
		#tests the scope called current
		expected = Student.all.where("ProgStatus in (?) and EnrollmentStatus='Active Student'", ['Candidate', 'Prospective'])
		actual = Student.current
		assert_equal(expected.slice(0, expected.size), actual.slice(0, actual.size))

	end

	test "candidates scope" do
		expected = Student.all.where("ProgStatus='Candidate' and EnrollmentStatus='Active Student'")
		actual = Student.candidates
		assert_equal(expected.slice(0, expected.size), actual.slice(0, actual.size))
	end

	test "from alt_id scope" do
		#pulls a student based on their alt_id.

		s = Student.from_alt_id(2)
		assert_equal(s.ProgStatus, "Candidate")		#this student should be the only one with ProgStatus of "Candidate"
	end

	test "is advisee of passes" do
		assignment = AdvisorAssignment.first
		s = assignment.student
		adv = assignment.tep_advisor
		assert s.is_advisee_of(adv.AdvisorBnum)
	end

	test "is advisee of fails" do
		assignment = AdvisorAssignment.first
		s = assignment.student
		adv = assignment.tep_advisor
		assert (s.is_advisee_of("bad bnum") == false)
	end

	test "is student of passes" do
		term = ApplicationController.helpers.current_term({:exact => false, :plan_b => :forward})		

		#update course with the term that the model expects in order to pass
		course = Transcript.first
		course.term_taken = term.BannerTerm
		assert course.valid?
		course.save

		stu = course.student
		prof_bnum = course.Inst_bnum
		assert stu.is_student_of(prof_bnum), "inst B# is " + prof_bnum
	end

	test "is student of fails bad term" do
		#fails because student doesn't have professor in the current term

		course = Transcript.first
		course.term_taken = 195301
		assert course.valid?
		course.save
		stu = course.student
		prof_bnum = course.Inst_bnum
		assert stu.is_student_of(prof_bnum) == false
	end

	test "is student of fails not student" do
		term = ApplicationController.helpers.current_term({:exact => false, :plan_b => :forward})		

		#fails because student doesn't have this prof (in fact the Bnum is completly bogus)
		course = Transcript.first
		course.term_taken = term.BannerTerm
		assert course.valid?
		course.save

		stu = course.student
		prof_bnum = course.Inst_bnum
		assert stu.is_student_of("bogus bnum") == false
	end

	test "praxisI_pass" do
		Student.all.each do |stu|
		   	req_tests = PraxisTest.where(TestFamily: 1, CurrentTest: 1).map{ |t| t.TestCode}
		   	all_passed = PraxisResult.where(Bnum: stu.Bnum, Pass: 1).map{ |p| p.TestCode}
		   	passing = true

		   	req_tests.each do |requirement|
		   		if not all_passed.include? requirement
		   			passing = false	
	   			end
		   	end
	   	
			assert_equal stu.praxisI_pass, passing
		end

	end
end

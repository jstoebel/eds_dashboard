# == Schema Information
#
# Table name: students
#
#  id               :integer          not null, primary key
#  Bnum             :string(9)        not null
#  FirstName        :string(45)       not null
#  PreferredFirst   :string(45)
#  MiddleName       :string(45)
#  LastName         :string(45)       not null
#  PrevLast         :string(45)
#  ProgStatus       :string(45)       default("Prospective")
#  EnrollmentStatus :string(45)
#  Classification   :string(45)
#  CurrentMajor1    :string(45)
#  CurrentMajor2    :string(45)
#  TermMajor        :integer
#  PraxisICohort    :string(45)
#  PraxisIICohort   :string(45)
#  CellPhone        :string(45)
#  CurrentMinors    :string(45)
#  Email            :string(100)
#  CPO              :string(45)
#
# Indexes
#
#  Bnum_UNIQUE  (Bnum) UNIQUE
#

require 'test_helper'
require 'minitest/autorun'

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

	test "is advisee of passes" do
		assignment = AdvisorAssignment.first
		s = assignment.student
		adv = assignment.tep_advisor
		assert s.is_advisee_of(adv)
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
		assert stu.is_student_of?(prof_bnum), "inst B# is " + prof_bnum
	end

	test "is student of fails bad term" do
		#fails because student doesn't have professor in the current term

		course = Transcript.first
		course.term_taken = 195301
		assert course.valid?
		course.save
		stu = course.student
		prof_bnum = course.Inst_bnum
		assert stu.is_student_of?(prof_bnum) == false
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
		assert stu.is_student_of?("bogus bnum") == false
	end

	test "praxisI_pass" do
		Student.all.each do |stu|
		   	req_tests = PraxisTest.where(TestFamily: 1, CurrentTest: 1).map{ |t| t.TestCode}
		   	all_passed = PraxisResult.where(student_id: stu.Bnum, Pass: 1).map{ |p| p.praxis_test_id}
		   	passing = true

		   	req_tests.each do |requirement|
		   		if not all_passed.include? requirement
		   			passing = false	
	   			end
		   	end
	   	
			assert_equal stu.praxisI_pass, passing
		end
	end

	test "latest_foi" do
		stu = Foi.first.student
		assert_equal stu.foi.order(:date_completing).last, stu.latest_foi
	end

	test "was_dismissed" do
		stu = Student.first
		stu.EnrollmentStatus = "Dismissed - Academic"
		stu.save
		assert stu.was_dismissed?
	end

	test "was_dismissed false" do
		stu = Student.first
		stu.EnrollmentStatus = "Active Student"
		stu.save
		assert_not stu.was_dismissed?		
	end

	test "returns prospective no foi" do
		Foi.delete_all
		AdmTep.delete_all
		s = Student.first
		s.EnrollmentStatus = "Active Student"
		s.save
		assert_equal "Prospective", s.prog_status
	end

	test "returns prospective positive foi" do
		stu = Student.first

		#remove all FOIs and adm_tep
		form = Foi.first
		Foi.delete_all
		AdmTep.delete_all
		form.seek_cert = true
		form.student_id = stu.id
		form.save

		stu.EnrollmentStatus = "Active Student"
		stu.save

		assert_equal "Prospective", stu.prog_status
	end

	test "returns not applying foi" do
		stu = Student.first

		#remove all FOIs and adm_tep
		form = Foi.first
		Foi.delete_all
		AdmTep.delete_all

		form.seek_cert = true
		form.student_id = stu.id
		form.save

		stu.EnrollmentStatus = "Active Student"
		stu.save

		assert_equal "Prospective", stu.prog_status

	end

	test "returns not applying dismissed" do
		stu = Student.first
		Foi.delete_all

		stu.EnrollmentStatus = "Dismissed - Academic"
		stu.save
		assert_equal "Not applying", stu.prog_status
	end

	test "returns candidate" do
		ProgExit.delete_all
		app = AdmTep.find_by :TEPAdmit => true
		assert_equal "Candidate", app.student.prog_status
	end

	test "returns dropped" do

		my_exit = ProgExit.first
		stu = my_exit.student

		#delete all exits and start over
		ProgExit.delete_all

		#get the code for exit
		drop_exit = ExitCode.find_by :ExitCode => "1809"

		#create a new exit that isn't a completion
		my_exit.ExitCode_ExitCode = drop_exit.id
		my_exit.RecommendDate = nil
		new_exit = ProgExit.new my_exit.attributes

		#make sure the new 
		assert new_exit.save, new_exit.errors.full_messages

		assert_equal "Dropped", stu.prog_status

	end

	test "returns completer" do
		completer_code = ExitCode.find_by :ExitCode => "1849"
		my_exit = ProgExit.find_by :ExitCode_ExitCode => completer_code.id 
		stu = my_exit.student
		assert_equal "Completer", stu.prog_status
	end

	test "returns completer with one drop" do
		completer_code = ExitCode.find_by :ExitCode => "1849"
		my_exit = ProgExit.find_by :ExitCode_ExitCode => completer_code.id 
		stu = my_exit.student
		old_app = my_exit.adm_tep

		#create a second admission
		second_program = Program.where.not(:id => my_exit.ExitCode_ExitCode).first
		second_adm = AdmTep.new old_app.attributes
		second_adm.Program_ProgCode = second_program.id
		second_adm.id = nil
		attach_letter second_adm

		assert second_adm.save, second_adm.errors.full_messages

	end

	test "open_programs" do
		stu = Student.first
		apps = stu.adm_tep.where(:TEPAdmit => true)
		expected = apps.select { |a| ProgExit.find_by({:student_id => a.student_id, :Program_ProgCode => a.Program_ProgCode}) == nil }
		
		assert_equal expected.to_a, stu.open_programs.to_a
	end

end

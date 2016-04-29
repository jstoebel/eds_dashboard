# == Schema Information
#
# Table name: prog_exits
#
#  id                :integer          not null, primary key
#  student_id        :integer          not null
#  Program_ProgCode  :integer          not null
#  ExitCode_ExitCode :integer          not null
#  ExitTerm          :integer          not null
#  ExitDate          :datetime
#  GPA               :float(24)
#  GPA_last60        :float(24)
#  RecommendDate     :datetime
#  Details           :text
#

require 'test_helper'

class ProgExitTest < ActiveSupport::TestCase
	fixtures :all

  test "scope by_term" do
  	expected = ProgExit.where("ExitTerm= ?", 201511).to_a
  	actual = ProgExit.by_term(201511).to_a
  	assert_equal(expected, actual)
  end

	test "blank bnum bad" do
		t = ProgExit.first
		t.student_id = nil
		t.valid?
		assert_equal(["Please select a student."], t.errors[:student_id])		
	end

	test "no program code" do

		exit = ProgExit.first
		exit.Program_ProgCode = nil
		exit.valid?
		assert_equal(["Please select a program."], exit.errors[:Program_ProgCode])
		
	end

	test "no exit code" do
		exit = ProgExit.first
		exit.ExitCode_ExitCode = nil
		exit.valid?
		assert_equal(["Please select an exit code."], exit.errors[:ExitCode_ExitCode])
	end

	test "date out of range" do
		#tests what happens if an out of range exit date is given 
		exit = ProgExit.first
		exit.ExitDate = Date.strptime("01/01/3000", "%m/%d/%Y")
		exit.valid?
		assert_equal(["Exit date out of range."], exit.errors[:ExitDate])

	end

	#ADVANCED VALIDATIONS
	test "Bad oveall GPA" do
		exit = ProgExit.first
		exit.GPA = 2.49
		exit.valid?
		assert_equal([], exit.errors[:base])
	end

	test "Bad last 60 GPA" do
		exit = ProgExit.first
		exit.GPA_last60 = 2.99
		exit.valid?
		assert_equal([], exit.errors[:base])
	end

	test "Bad GPA both" do
		exit = ProgExit.first
		exit.GPA = 2.49
		exit.GPA_last60 = 2.99
		exit.valid?
		# assert (exit.GPA == 2.49 and exit.GPA_last60 == 2.99)
		assert_equal(["Student must have 2.5 GPA or 3.0 in the last 60 credit hours."], exit.errors[:base])
	end

	test "require exit before recommendation" do
		exit = ProgExit.first
		exit.RecommendDate = exit.ExitDate - 1
		exit.valid?
		assert_includes exit.errors[:RecommendDate], "Student may not be recommended for certification before exiting program."
	end

	test "require completer for recommendation" do
		exit = ProgExit.first
		exit.ExitCode_ExitCode = "1826"
		exit.valid?
		assert_equal(["Student may not be recommended for certificaiton unless they have sucessfully completed the program."], exit.errors[:RecommendDate])
	end

	test "require completer before completion" do
		exit = ProgExit.first
		stu = exit.student
		stu.EnrollmentStatus = "Active Student"
		stu.save
		exit.valid?
		assert_equal(["Student must have graduated in order to complete their program."], exit.errors[:ExitCode_ExitCode])
	end


	test "no exit if not enrolled" do
		#try to exit the prospective
		stu = Student.where("ProgStatus=?", "Prospective").first
		adm = stu.adm_tep.first

		term = ApplicationController.helpers.current_term({
			:exact => false,
			:plan_b => :back
		})

		exit = ProgExit.new({
			student_id: stu.id,
			Program_ProgCode: adm.Program_ProgCode,
			ExitCode_ExitCode: "1849",
			ExitTerm: 201511,
			ExitDate: term.StartDate,
			GPA: 3.0,
			GPA_last60: 3.0
			})
		exit.save
		assert_equal(["Student was never admitted to this program."], exit.errors[:Program_ProgCode])
	end

	test "no exit if alread exited" do
		exit = ProgExit.first
		exit2 = ProgExit.new(exit.attributes.except("id"))
		exit2.save
		assert_equal(["Student has already exited this program."], exit2.errors[:Program_ProgCode])
	end

	test "add term" do
		exit_old = ProgExit.first
		exit_attrs = exit_old.attributes
		exit_old.destroy	#destroy the current record so we can recreate
		exit_new = ProgExit.new(exit_attrs.except("id", "ExitTerm"))
		exit_new.save
		assert_equal(exit_new.ExitTerm, 201511)
	end

	test "change status to completer" do

		# THIS TEST IS BROKEN AND THIS FETURE WILL BE REIMPLEMENTED SOON
		# stu = Student.where(ProgStatus: "Candidate", EnrollmentStatus: "Graduation").first
		# adm_app = stu.adm_tep.find_by(TEPAdmit: true)
		# #make an exit for this student
		# new_exit = ProgExit.new

		# exit_term = ApplicationController.helpers.current_term({
		# 	:exact => false,
		# 	:plan_b => :forward,
		# 	:date => (adm_app.TEPAdmitDate) + 360	#1 year after admit
		# })

		# completer_code = ExitCode.find_by :ExitCode => "1849"

		# new_exit.update_attributes({
		# 	student_id: stu.id, Program_ProgCode: stu.programs.first.id, 
		# 	ExitCode_ExitCode: completer_code.id, ExitTerm: exit_term, 
		# 	ExitDate: exit_term.StartDate, GPA: 3, GPA_last60: 3,})


		# assert_equal "Completer", stu.ProgStatus

	end

	test "change status to dropped" do

		# THIS TEST IS BROKEN AND THIS FETURE WILL BE REIMPLEMENTED SOON
		# #admit the prospective student,
		# stu = Student.find_by(ProgStatus: "Candidate", EnrollmentStatus: "Active Student")
		# adm_apps = stu.adm_tep.where(TEPAdmit: true)
		
		# #for each app, exit as dropped
		# adm_apps.each do |app|

		# 	#exit as completer
		# 	new_exit = ProgExit.new
		# 	exit_date = (app.TEPAdmitDate) + 365
		# 	exit_term = ApplicationController.helpers.current_term(exact: false, date: exit_date)

		# 	drop_code = ExitCode.find_by :ExitCode => "1826"
		# 	new_exit.update_attributes(
		# 		{student_id: stu.id, Program_ProgCode: app.Program_ProgCode, 
		# 			ExitCode_ExitCode: drop_code.id, ExitTerm: exit_term, 
		# 			ExitDate: exit_date, GPA: 3, GPA_last60: 3})

		# end
		# assert_equal 0, AdmTep.open(stu.id).size
		# assert_equal("Dropped", stu.ProgStatus)
	end

end 

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
#  Details           :text(65535)
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
		prog_exit = FactoryGirl.create :successful_prog_exit
		prog_exit.student_id = nil
		prog_exit.valid?
		assert_equal(["Please select a student."], prog_exit.errors[:student_id])
	end

	# test "no program code" do
	#
	# 	exit = ProgExit.first
	# 	exit.Program_ProgCode = nil
	# 	exit.valid?
	# 	assert_equal(["Please select a program."], exit.errors[:Program_ProgCode])
	#
	# end
	#
	# test "no exit code" do
	# 	exit = ProgExit.first
	# 	exit.ExitCode_ExitCode = nil
	# 	exit.valid?
	# 	assert_equal(["Please select an exit code."], exit.errors[:ExitCode_ExitCode])
	# end
	#
	# test "date out of range" do
	# 	#tests what happens if an out of range exit date is given
	# 	exit = ProgExit.first
	# 	exit.ExitDate = Date.new(1865, 1, 1)	#date is less than begining of time
	# 	exit.valid?
	# 	assert_equal(["Exit date out of range."], exit.errors[:ExitDate])
	#
	# end
	#
	# #ADVANCED VALIDATIONS
	# test "Bad oveall GPA" do
	# 	exit = ProgExit.first
	# 	exit.GPA = 2.49
	# 	exit.valid?
	# 	assert_equal([], exit.errors[:base])
	# end
	#
	# test "Bad last 60 GPA" do
	# 	exit = ProgExit.first
	# 	exit.GPA_last60 = 2.99
	# 	exit.valid?
	# 	assert_equal([], exit.errors[:base])
	# end
	#
	# test "Bad GPA both" do
	# 	exit = ProgExit.first
	# 	exit.GPA = 2.49
	# 	exit.GPA_last60 = 2.99
	# 	exit.valid?
	# 	# assert (exit.GPA == 2.49 and exit.GPA_last60 == 2.99)
	# 	assert_equal(["Student must have 2.5 GPA or 3.0 in the last 60 credit hours."], exit.errors[:base])
	# end
	#
	# test "require exit before recommendation" do
	# 	exit = ProgExit.first
	# 	exit.RecommendDate = exit.ExitDate - 1
	# 	exit.valid?
	# 	assert_includes exit.errors[:RecommendDate], "Student may not be recommended for certification before exiting program."
	# end

	test "require completer for recommendation" do
		prog_exit = FactoryGirl.create :successful_prog_exit
		prog_exit.ExitCode_ExitCode = "1826"
		prog_exit.valid?
		assert_equal(["Student may not be recommended for certificaiton unless they have sucessfully completed the program."], prog_exit.errors[:RecommendDate])
	end

	# test "require completer before completion" do
	# 	exit = ProgExit.first
	# 	stu = exit.student
	# 	stu.EnrollmentStatus = "Active Student"
	# 	stu.save
	# 	exit.valid?
	# 	assert_equal(["Student must have graduated in order to complete their program."], exit.errors[:ExitCode_ExitCode])
	# end
	#
	#
	# test "no exit if not enrolled" do
	# 	#try to exit a student with no admissions
	# 	stu = Student.first
	#
	# 	AdmTep.delete_all
	#
	# 	term = BannerTerm.current_term({
	# 		:exact => false,
	# 		:plan_b => :back
	# 	})
	#
	# 	exit = ProgExit.new({
	# 		student_id: stu.id,
	# 		Program_ProgCode: Program.first.id,
	# 		ExitCode_ExitCode: ExitCode.first.id,
	# 		ExitDate: Date.today,
	# 		GPA: 3.0,
	# 		GPA_last60: 3.0
	# 		})
	# 	exit.save
	# 	assert_equal(["Student was never admitted to this program."], exit.errors[:Program_ProgCode])
	# end
	#
	# test "add term" do
	#
	#
	# 	exit_old = ProgExit.first
	# 	exit_attrs = exit_old.attributes
	# 	exit_old.destroy	#destroy the current record so we can recreate
	# 	exit_new = ProgExit.new(exit_attrs.except("id", "ExitTerm"))
	# 	pop_transcript(exit_new.student, 12, 2.0, exit_new.banner_term.prev_term)
	# 	exit_new.save
	# 	assert_equal(exit_new.ExitTerm, exit_old.ExitTerm)
	# end


end

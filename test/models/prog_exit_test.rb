require 'test_helper'

class ProgExitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "scope by_term" do
  	expected = ProgExit.where("ExitTerm= ?", 201511).to_a
  	actual = ProgExit.by_term(201511).to_a
  	py_assert(expected, actual)
  end

 #  #TESTS FOR STUDENT BNUM
	# test "bnum matches regex1" do
	# 	t = ProgExit.first
	# 	t.Student_Bnum = "00123456"
	# 	t.valid?
	# 	py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Student_Bnum])
	# end

	# test "bnum matches regex2" do
	# 	t = ProgExit.first
	# 	t.Student_Bnum = "B001234567"
	# 	t.valid?
	# 	py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Student_Bnum])
	# end

	# test "bnum matches regex3" do
	# 	t = ProgExit.first
	# 	t.Student_Bnum = "123456"
	# 	t.valid?
	# 	py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Student_Bnum])
	# end

	# test "bnum matches regex4" do
	# 	t = ProgExit.first
	# 	t.Student_Bnum = "B0012345"
	# 	t.valid?
	# 	py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Student_Bnum])
	# end

	# test "bnum matches regex5" do
	# 	t = ProgExit.first
	# 	t.Student_Bnum = "completly off!"
	# 	t.valid?
	# 	py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Student_Bnum])
	# end

	test "blank bnum bad" do
		t = ProgExit.first
		t.Student_Bnum = nil
		t.valid?
		py_assert(["Please select a student."], t.errors[:Student_Bnum])		
	end

	test "no program code" do

		exit = ProgExit.first
		exit.Program_ProgCode = nil
		exit.valid?
		py_assert(["Please select a program."], exit.errors[:Program_ProgCode])
		# adm = AdmTep.where(TEPAdmit: true).first		#here is a program the student was already admitted to and exit
		# adm.Program_ProgCode = nil


		# adm2 = AdmTep.new(adm.attributes)

		# #lets find a new program to enter
		# new_program = Program.where.not(ProgCode: adm.Program_ProgCode)
		# adm2.Program_ProgCode = new_program
		# adm2.TEPAdmitDate = Date.today

		# #now lets exit from this program
		# first_exit = ProgExit.first
		# exit2 = ProgExit.new(first_exit.attributes)
		# exit2.Program_ProgCode = nil
		# exit2.valid?
		# py_assert(["Please select a program."], exit2.errors[:Program_ProgCode])		
	end

	test "no exit code" do
		exit = ProgExit.first
		exit.ExitCode_ExitCode = nil
		exit.valid?
		py_assert(["Please select an exit code."], exit.errors[:ExitCode_ExitCode])
	end

	test "no exit term" do
		exit = ProgExit.first
		exit.ExitTerm = nil
		exit.valid?
		py_assert(["No exit term could be determined."], exit.errors[:ExitTerm])
	end

	#ADVANCED VALIDATIONS
	test "Bad oveall GPA" do
		exit = ProgExit.first
		exit.GPA = 2.49
		exit.valid?
		py_assert([], exit.errors[:base])
	end

	test "Bad last 60 GPA" do
		exit = ProgExit.first
		exit.GPA_last60 = 2.99
		exit.valid?
		py_assert([], exit.errors[:base])
	end

	test "Bad GPA both" do
		exit = ProgExit.first
		exit.GPA = 2.49
		exit.GPA_last60 = 2.99
		exit.valid?
		py_assert(["Student must have 2.5 GPA or 3.0 in the last 60 credit hours."], exit.errors[:base])
	end

	test "require exit before recommendation" do
		exit = ProgExit.first
		exit.RecommendDate = exit.ExitDate - 1
		exit.valid?
		py_assert(["Student may not be recommended for certification before exiting program."], exit.errors[:RecommendDate])
	end

	test "require completer for recommendation" do
		exit = ProgExit.first
		exit.ExitCode_ExitCode = "1826"
		exit.valid?
		py_assert(["Student may not be recommended for certificaiton unless they have sucessfully completed the program."], exit.errors[:RecommendDate])
	end

	test "require completer before completion" do
		exit = ProgExit.first
		exit.valid?
		py_assert(["Student must have graduated in order to complete their program."], exit.errors[:ExitCode_ExitCode])
	end

	test "no exit if not admitted"

	test "no exit if not enrolled" do
		exit = ProgExit.first
		exit2 = ProgExit.new(exit.attributes)		#try to exit from the same program a second time.
		# exit2.Program_ProgCode = "something else"
		exit2.valid?
		py_assert(["Student may not be exited from a program that they are not currently enrolled in."], exit2.errors[:Program_ProgCode])
	end
end 

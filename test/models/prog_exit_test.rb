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

  #TESTS FOR STUDENT BNUM
	test "bnum matches regex1" do
		t = ProgExit.first
		t.Student_Bnum = "00123456"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Student_Bnum])
	end

	test "bnum matches regex2" do
		t = ProgExit.first
		t.Student_Bnum = "B001234567"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Student_Bnum])
	end

	test "bnum matches regex3" do
		t = ProgExit.first
		t.Student_Bnum = "123456"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Student_Bnum])
	end

	test "bnum matches regex4" do
		t = ProgExit.first
		t.Student_Bnum = "B0012345"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Student_Bnum])
	end

	test "bnum matches regex5" do
		t = ProgExit.first
		t.Student_Bnum = "completly off!"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Student_Bnum])
	end

	test "blank bnum bad" do
		t = ProgExit.first
		t.Student_Bnum = nil
		t.valid?
		py_assert(["Please select a student."], t.errors[:Student_Bnum])		
	end

	test "need program code" do
		adm = AdmTep.where(TEPAdmit: true).first		#here is a program the student was already admitted to and exit
		adm2 = AdmTep.new(adm.attributes)

		#lets find a new program to enter
		new_program = Program.where.not(ProgCode: adm.Program_ProgCode)
		adm2.Program_ProgCode = new_program
		adm2.TEPAdmitDate = Date.today

		#now lets exit from this program
		first_exit = ProgExit.first
		exit2 = ProgExit.new(first_exit.attributes)
		exit2.Program_ProgCode = 
		exit2.
		exit2.valid?
		
		# t = ProgExit.where(Student_Bnum: stu.Bnum).where(Program_ProgCode: prog.ProgCode).first
		# t.Program_ProgCode = nil
		# t.valid?
		# py_assert(["Please select a program."], t.errors[:Program_ProgCode])
	end
end

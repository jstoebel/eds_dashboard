require 'test_helper'

class ProgExitTest < ActiveSupport::TestCase
	fixtures :all
  # test "the truth" do
  #   assert true
  # end

  test "scope by_term" do
  	expected = ProgExit.where("ExitTerm= ?", 201511).to_a
  	actual = ProgExit.by_term(201511).to_a
  	py_assert(expected, actual)
  end

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
		
	end

	test "no exit code" do
		exit = ProgExit.first
		exit.ExitCode_ExitCode = nil
		exit.valid?
		py_assert(["Please select an exit code."], exit.errors[:ExitCode_ExitCode])
	end

	test "date out of range" do
		#tests what happens if an out of range exit date is given 
		exit = ProgExit.first
		exit.ExitDate = Date.strptime("01/01/3000", "%m/%d/%Y")
		exit.valid?
		py_assert(["Exit date out of range."], exit.errors[:ExitDate])

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


	test "no exit if not enrolled" do
		#try to exit the prospective
		stu = Student.where("ProgStatus=?", "Prospective").first
		adm = stu.adm_tep.first
		exit = ProgExit.new({
			Student_Bnum: stu.Bnum,
			Program_ProgCode: adm.Program_ProgCode,
			ExitCode_ExitCode: "1849",
			ExitTerm: 201511,
			ExitDate: Date.today,
			GPA: 3.0,
			GPA_last60: 3.0
			})
		exit.save
		py_assert(["Student was never admitted to this program."], exit.errors[:Program_ProgCode])
	end

	test "no exit if alread exited" do
		exit = ProgExit.first
		exit2 = ProgExit.new(exit.attributes.except("id"))
		exit2.save
		py_assert(["Student has already exited this program."], exit2.errors[:Program_ProgCode])
	end

	test "add term" do
		exit_old = ProgExit.first
		exit_attrs = exit_old.attributes
		exit_old.destroy	#destroy the current record so we can recreate
		exit_new = ProgExit.new(exit_attrs.except("id", "ExitTerm"))
		exit_new.save
		py_assert(exit_new.ExitTerm, 201511)
	end

	test "change status to completer" do

		#admit the prospective student,
		stu = Student.where("ProgStatus=?", "Prospective").first
		adm_tep = AdmTep.where(Student_Bnum: stu.Bnum).first
		adm_tep.update_attributes({:TEPAdmit => true, TEPAdmitDate: Date.today-1})
		adm_tep.save

		assert(adm_tep.student.ProgStatus=="Candidate", "Student status is not being changed to Candidate")

		#change her to Graduation
		stu.EnrollmentStatus = "Graduation"
		stu.save

		#exit as completer
		exit = ProgExit.new
		exit.update_attributes({Student_Bnum: stu.Bnum, Program_ProgCode: stu.programs.first.ProgCode, ExitCode_ExitCode: "1849", ExitTerm: 201511, ExitDate: Date.today, GPA: 3, GPA_last60: 3,})

		py_assert("Completer", exit.student.ProgStatus)

	end

	test "change status to dropped" do
		#admit the prospective student,
		stu = Student.where("ProgStatus=?", "Prospective").first
		adm_tep = AdmTep.where(Student_Bnum: stu.Bnum).first
		adm_tep.update_attributes({:TEPAdmit => true, TEPAdmitDate: Date.today-1})
		adm_tep.save

		assert(adm_tep.student.ProgStatus=="Candidate", "Student status is not being changed to Candidate")

		#exit as completer
		exit = ProgExit.new
		exit.update_attributes({Student_Bnum: stu.Bnum, Program_ProgCode: stu.programs.first.ProgCode, ExitCode_ExitCode: "1826", ExitTerm: 201511, ExitDate: Date.today, GPA: 3, GPA_last60: 3,})

		py_assert("Dropped", exit.student.ProgStatus)
	end

end 

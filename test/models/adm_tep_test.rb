require 'test_helper'

class AdmTepTest < ActiveSupport::TestCase
	
	# test "data are right" do
	# 	app = AdmTep.first
	# 	self.my_assert(app.Student_Bnum, app.student.Bnum.to_s)
 # 	end

  test "scope admitted" do
    admit_count = AdmTep.admitted.size
    py_assert(admit_count, 1)
  end

  test "open programs" do
    stu = AdmTep.admitted.first.student

    expected = AdmTep.where(Student_Bnum: stu.Bnum)
    actual = 

    py_assert(open_programs, AdmTep.where(Student_Bnum: stu.Bnum))
  end

  test "needs foreign keys" do
  	#test validation: needing a program.
    app = AdmTep.new
    app.valid?
    py_assert(app.errors[:Student_Bnum], ["No student selected."])
    py_assert(app.errors[:Program_ProgCode], ["No program selected."])
    py_assert(app.errors[:BannerTerm_BannerTerm], ["No term could be determined."])
  end

  test "admit date empty" do

    # stu = Student.first
    # prog = Program.first
    # term = BannerTerm.first
    app = AdmTep.first
    app.valid?
    py_assert(app.errors[:TEPAdmitDate], ["Admission date must be given."])

  end

  test "admit date too early" do
    app = AdmTep.first
    app.TEPAdmitDate = Date.strptime("8/31/2015", "%m/%d/%Y")
    app.valid?
    py_assert(app.errors[:TEPAdmitDate], ["Admission date must be after term begins."])

  end

  test "admit date too late" do
    app = AdmTep.first
    app.TEPAdmitDate = Date.strptime("01/01/2016", "%m/%d/%Y")
    app.valid?
    py_assert(app.errors[:TEPAdmitDate], ["Admission date must be before next term begins."])

  end



end

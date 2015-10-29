require 'test_helper'

class AdmTepTest < ActiveSupport::TestCase
	
	# test "data are right" do
	# 	app = AdmTep.first
	# 	self.my_assert(app.Student_Bnum, app.student.Bnum.to_s)
 # 	end

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
    app.TEPAdmitDate = Date.strptime("8/31/15", "%m/%d/%Y")
    app.valid?
    py_assert(app.errors[:TEPAdmitDate], ["Admission date must be after term begins."])

  end



end

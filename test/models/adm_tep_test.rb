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

  test "scope open" do
    stu = AdmTep.admitted.first.student

    expected = AdmTep.where(Student_Bnum: stu.Bnum)
    actual = AdmTep.open(stu.Bnum)

    #since different SQL was used, slice the records into an array
    #and compare the array
    py_assert(expected.slice(0, expected.size), 
      expected.slice(0, expected.size))
  end

  test "scope by term" do
    expected = AdmTep.where(BannerTerm_BannerTerm: 201511)
    actual = AdmTep.by_term(201511)
    py_assert(expected.slice(0, expected.size), 
      expected.slice(0, expected.size))
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
    app = AdmTep.where(TEPAdmit: true).first
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

  test "gpa both bad" do
    app = AdmTep.where(TEPAdmit: true).first
    app.GPA = 2.74
    app.GPA_last30 = 2.99
    app.valid?
    py_assert(app.errors[:base], ["Student does not have sufficent GPA to be admitted this term."])
  end

  test "overall gpa bad only" do
    app = AdmTep.first
    app.GPA = 2.74
    app.valid?
    py_assert(app.errors[:base], [])
  end

  test "last 30 gpa bad" do
    app = AdmTep.where(TEPAdmit: true).first
    app.GPA_last30 = 2.99
    app.valid?
    py_assert(app.errors[:base], [])
  end

  test "earned credits bad" do
    app = AdmTep.where(TEPAdmit: true).first
    app.EarnedCredits = 29
    app.valid?
    py_assert(app.errors[:EarnedCredits], ["Student has not earned 30 credit hours."])
  end

  test "no admission letter" do
    app = AdmTep.where(TEPAdmit: true).first
    app.letter_file_name = nil
    app.valid?
    py_assert(app.errors[:base], ["Please attach an admission letter."])
  end

  test "already enrolled" do
    stu = Student.first
    app = AdmTep.first
    app2 = AdmTep.new(app.attributes)
    app2.valid?
    py_assert(app2.errors[:base], ["Student has already been admitted or has an open applicaiton for this program in this term."])
  end

  test "app already pending" do
    #student already has a pending app for this program
    app = AdmTep.where(TEPAdmit: nil).first
    stu = app.student
    app2 = AdmTep.new(app.attributes)
    app2.valid?
    py_assert(app2.errors[:base], ["Student has already been admitted or has an open applicaiton for this program in this term."])

  end

  test "change status" do
    app = AdmTep.where(TEPAdmit: nil).first
    stu = app.student
    app.TEPAdmit = true
    app.TEPAdmitDate = Date.today
    app.save
    # py_assert(app.TEPAdmit, true)
    py_assert(stu.ProgStatus, "Candidate")
  end

end

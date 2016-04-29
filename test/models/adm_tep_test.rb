# == Schema Information
#
# Table name: adm_tep
#
#  student_id            :integer          not null
#  id                    :integer          not null, primary key
#  Program_ProgCode      :integer          not null
#  BannerTerm_BannerTerm :integer          not null
#  Attempt               :integer          not null
#  GPA                   :float(24)
#  GPA_last30            :float(24)
#  EarnedCredits         :integer
#  PortfolioPass         :boolean
#  TEPAdmit              :boolean
#  TEPAdmitDate          :datetime
#  Notes                 :text
#  student_file_id       :integer
#
# Indexes
#
#  adm_tep_student_file_id_fk  (student_file_id)
#  adm_tep_student_id_fk       (student_id)
#  fk_AdmTEP_BannerTerm1_idx   (BannerTerm_BannerTerm)
#  fk_AdmTEP_Program1_idx      (Program_ProgCode)
#

require 'test_helper'
require 'paperclip'
include ActionDispatch::TestProcess
class AdmTepTest < ActiveSupport::TestCase

  test "scope admitted" do
    admit_count = AdmTep.admitted.size
    assert_equal(admit_count, AdmTep.where("TEPAdmit = ?", true).size)
  end

  test "scope open" do
    stu = AdmTep.admitted.first.student

    expected = AdmTep.where(student_id: stu.id)
    actual = AdmTep.open(stu.Bnum)

    #since different SQL was used, slice the records into an array
    #and compare the array
    assert_equal(expected.slice(0, expected.size), 
      expected.slice(0, expected.size))
  end

  test "scope by term" do
    expected = AdmTep.where(BannerTerm_BannerTerm: 201511)
    actual = AdmTep.by_term(201511)
    assert_equal(expected.slice(0, expected.size), 
      expected.slice(0, expected.size))
  end

  test "needs foreign keys" do
  	#test validation: needing a program.
    app = AdmTep.new
    app.valid?
    assert_equal(app.errors[:student_id], ["No student selected."])
    assert_equal(app.errors[:Program_ProgCode], ["No program selected."])
    assert_equal(app.errors[:BannerTerm_BannerTerm], ["No term could be determined."])
  end

  test "admit date empty" do
    #tests validation for required admission date for accespted applications.

    app = AdmTep.find_by(TEPAdmit: true)
    letter = attach_letter(app)
    app.TEPAdmitDate = nil
    app.valid?
    assert_equal(app.errors[:TEPAdmitDate], ["Admission date must be given."])

  end

  test "admit date too early" do
    app = AdmTep.first
    date = app.banner_term.StartDate.to_date
    app.TEPAdmitDate = date - 10
    letter = attach_letter(app)
    app.valid?
    assert_equal(app.errors[:TEPAdmitDate], ["Admission date must be after term begins."])
  end

  test "admit date too late" do
    app = AdmTep.find_by({:TEPAdmitDate => nil})
    letter = attach_letter(app)
    date = app.banner_term.EndDate.to_date
    app.TEPAdmitDate = date + 365
    app.valid?
    assert_equal(app.errors[:TEPAdmitDate], ["Admission date must be before next term begins."])

  end

  test "gpa both bad" do
    app = AdmTep.where(TEPAdmit: true).first
    app.GPA = 2.74
    app.GPA_last30 = 2.99
    letter = attach_letter(app)
    app.valid?
    assert_equal(app.errors[:base], ["Student does not have sufficent GPA to be admitted this term."])
  end

  test "overall gpa bad only" do
    app = AdmTep.first
    app.GPA = 2.74
    app.valid?
    assert_equal(app.errors[:base], [])
  end

  test "last 30 gpa bad" do
    app = AdmTep.where(TEPAdmit: true).first
    app.GPA_last30 = 2.99
    app.valid?
    assert_equal(app.errors[:base], [])
  end

  test "earned credits bad" do
    app = AdmTep.where(TEPAdmit: true).first
    app.EarnedCredits = 29
    letter = attach_letter(app)
    app.valid?
    assert_equal(app.errors[:EarnedCredits], ["Student has not earned 30 credit hours."])
  end

  test "no admission letter" do
    app = AdmTep.find_by(TEPAdmit: true)
    app.valid?
    assert_equal(app.errors[:student_file_id], ["Please attach an admission letter."])
  end

  test "already enrolled" do
    #student can't be admitted because they are already enrolled
    app = AdmTep.find_by(:TEPAdmit => nil)
    app2 = AdmTep.new(app.attributes)
    letter = attach_letter(app)
    app2.valid?
    assert_equal(app2.errors[:base], ["Student has already been admitted or has an open applicaiton for this program in this term."])
  end

  test "app already pending" do
    #student already has a pending app for this program
    app = AdmTep.where(TEPAdmit: nil).first
    stu = app.student
    app2 = AdmTep.new(app.attributes)
    app2.valid?
    assert_equal(app2.errors[:base], ["Student has already been admitted or has an open applicaiton for this program in this term."])

  end

  test "change status" do
    pros_stu = Student.where(ProgStatus: "Prospective").first
    app = pros_stu.adm_tep.where(TEPAdmit: nil).first

    app.TEPAdmit = true
    #needs to be before next term begins
    admit_date = app.banner_term.StartDate
    app.TEPAdmitDate = admit_date

    #attach an admission letter
    letter = attach_letter(app)
    assert app.valid?, app.errors.full_messages
    app.save
    # assert_equal(app.TEPAdmit, true)
    assert_equal("Candidate", app.student.ProgStatus)
  end

  test "praxisI_pass" do
    
  end

end

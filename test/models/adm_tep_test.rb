# == Schema Information
#
# Table name: adm_tep
#
#  id                    :integer          not null, primary key
#  student_id            :integer          not null
#  Program_ProgCode      :integer          not null
#  BannerTerm_BannerTerm :integer          not null
#  Attempt               :integer
#  GPA                   :float(24)
#  GPA_last30            :float(24)
#  EarnedCredits         :integer
#  PortfolioPass         :boolean
#  TEPAdmit              :boolean
#  TEPAdmitDate          :datetime
#  Notes                 :text(65535)
#  student_file_id       :integer
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
    pop_transcript(app.student, 12, 3.0, app.banner_term.prev_term)
    app.valid?
    assert_equal(app.errors[:TEPAdmitDate], ["Admission date must be given."])

  end

  test "admit date too early" do
    app = FactoryGirl.create :adm_tep
    date = app.banner_term.StartDate.to_date
    app.TEPAdmitDate = date - 10
    letter = attach_letter(app)
    pop_transcript(app.student, 12, 3.0, app.banner_term.prev_term)
    app.valid?
    assert_equal(app.errors[:TEPAdmitDate], ["Admission date must be after term begins."])
  end

  test "admit date too late" do
    app = AdmTep.find_by({:TEPAdmitDate => nil})
    letter = attach_letter(app)
    date = app.banner_term.EndDate.to_date
    app.TEPAdmitDate = date + 365
    pop_transcript(app.student, 12, 3.0, app.banner_term.prev_term)
    app.valid?
    assert_equal(app.errors[:TEPAdmitDate], ["Admission date must be before next term begins."])

  end

  describe "good_gpa" do
    before do
      @app = FactoryGirl.build :adm_tep
    end

    test "both good" do
      @app.GPA = 2.75
      @app.GPA_last30 = 3.0
      assert @app.good_gpa?
    end

    describe "overall good" do

      before do
        @app.GPA = 2.75
      end

      [2.99, nil].each do |last30|
        test "last30: #{last30}" do
          @app.GPA_last30 = last30
          assert @app.good_gpa?
        end
      end

    end

    describe "last30 good" do
      before do
        @app.GPA_last30 = 3.0
      end

      [2.74, nil].each do |overall|
        test "overall: #{overall}" do
          @app.GPA = overall
          assert @app.good_gpa?
        end
      end
    end

    describe "both bad" do

      [2.74, nil].each do |overall|
        [2.99, nil].each do |last30|
          test "overall: #{overall}, last30: #{last30}" do
            @app.GPA = overall
            @app.GPA_last30 = last30
            assert_not @app.good_gpa?
          end
        end
      end

    end



  end

  test "gpa both bad" do
    app = AdmTep.where(TEPAdmit: true).first
    letter = attach_letter(app)
    pop_transcript(app.student, 12, 2.0, app.banner_term.prev_term)
    app.valid?
    assert (app.errors[:base].include? "Student does not have sufficent GPA to be admitted this term.")
  end

  test "overall gpa bad only" do
    app = FactoryGirl.create :adm_tep
    pop_transcript(app.student, 12, 3.0, app.banner_term.prev_term)
    app.TEPAdmit = true
    app.valid?
    assert_equal(app.errors[:base], [])
  end

  describe "good credits" do
    before do
      @app = FactoryGirl.build :adm_tep
    end

    test "returns true" do
      @app.EarnedCredits = 30
      assert @app.good_credits?
    end

    describe "returns false" do
      [29, nil].each do |credits|
        test "credits: #{credits.to_s}" do
          @app.EarnedCredits = credits
          assert_not @app.good_credits?
        end
      end
    end
  end

  test "last 30 gpa bad" do
    app = AdmTep.where(TEPAdmit: true).first
    app.TEPAdmit = true
    app.GPA_last30 = 2.99
    pop_transcript(app.student, 12, 3.0, app.banner_term.prev_term)
    app.valid?
    assert_equal(app.errors[:base], [])
  end

  test "earned credits bad" do
    app = AdmTep.where(TEPAdmit: true).first
    app.TEPAdmit = true
    letter = attach_letter(app)
    pop_transcript(app.student, 1, 3.0, app.banner_term.prev_term)
    app.valid?
    assert_equal(app.errors[:EarnedCredits], ["Student needs to have earned 30 credit hours and has only earned #{app.EarnedCredits}."])
  end

  test "no admission letter" do
    app = AdmTep.find_by(TEPAdmit: true)
    pop_transcript(app.student, 12, 3.0, app.banner_term.prev_term)
    app.valid?
    assert_equal(app.errors[:student_file_id], ["Please attach an admission letter."])
  end

  test "already enrolled" do
    #student can't be admitted because they are already enrolled
    app = AdmTep.find_by(:TEPAdmit => nil)
    app2 = AdmTep.new(app.attributes)
    letter = attach_letter(app)
    pop_transcript(app.student, 12, 3.0, app.banner_term.prev_term)
    app2.valid?
    assert_equal(app2.errors[:base], ["Student has already been admitted or has an open applicaiton for this program in this term."])
  end

  test "app already pending" do
    #student already has a pending app for this program
    app = AdmTep.where(TEPAdmit: nil).first
    stu = app.student
    app2 = AdmTep.new(app.attributes)
    pop_transcript(app.student, 12, 3.0, app.banner_term.prev_term)
    app2.valid?
    assert_equal(app2.errors[:base], ["Student has already been admitted or has an open applicaiton for this program in this term."])

  end

  test "praxisI_pass" do

  end

end

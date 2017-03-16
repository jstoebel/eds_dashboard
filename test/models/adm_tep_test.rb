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

  test "AdmTep False for same program" do
    stu = FactoryGirl.create :admitted_student
    program = stu.adm_tep.first.program
    banner = BannerTerm.first.id
    stu_file = FactoryGirl.create :student_file
    @app = FactoryGirl.build :adm_tep, {
      :student => stu,
      :program => program,
      :banner_term => stu.adm_tep.first.banner_term,
      :TEPAdmit => false
    }

    assert_raises ActiveRecord::RecordInvalid do
      @app.save!
    end # assert
  end # test

  describe "Second application with same program" do

    test "first application: true" do
      stu = FactoryGirl.create :admitted_student
      prog = stu.adm_tep.first.program
      term = stu.adm_tep.first.banner_term
      second_app = FactoryGirl.build :adm_tep, {:program => prog,
        :banner_term => term,
        :TEPAdmitDate => term.StartDate,
        :TEPAdmit => true
      }

      assert_raises ActiveRecord::RecordInvalid do
        second_app.save!
      end # assert

    end # test

    test "first application: false" do
      stu = FactoryGirl.create :student
      term = FactoryGirl.create :banner_term
      program = FactoryGirl.create :program
      first_adm_tep = FactoryGirl.build :adm_tep, {:program => program,
        :banner_term => term,
        :TEPAdmit => false,
        :TEPAdmitDate => nil
      }
      first_adm_tep.save!
      second_adm_tep = FactoryGirl.build :adm_tep, first_adm_tep.attributes
      assert second_adm_tep.valid?
    end # test

    test "first application: nil" do
      stu = FactoryGirl.create :student
      term = FactoryGirl.create :banner_term
      program = FactoryGirl.create :program
      first_adm_tep = FactoryGirl.build :adm_tep, {:student => stu,
        :program => program,
        :banner_term => term,
        :TEPAdmit => nil,
        :TEPAdmitDate => nil,
      }
      first_adm_tep.save!
      second_adm_tep = FactoryGirl.build :adm_tep, {:student => stu,
        :program => program,
        :TEPAdmit => false,
        :TEPAdmitDate => nil
      }
      assert_not second_adm_tep.valid?
    end # test
  end # describe

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

  test "Two unique programs with different banner terms" do
    stu = FactoryGirl.create :admitted_student
    app_term = stu.adm_tep.first.banner_term
    program = FactoryGirl.create :program

    #write code so that it finds a program that hasn't been used. Instead of relying on .first or .last
    banner = BannerTerm.first.id
    app = FactoryGirl.create :adm_tep, {:student_id => stu.id, :program => program, :banner_term => app_term,
    :TEPAdmitDate => app_term.StartDate, :GPA => 4.0, :GPA_last30 => 4.0, :EarnedCredits => 30}

    app.valid?
  end

  test "Unique Programs for AdmTep" do
    stu = FactoryGirl.create :admitted_student
    second_app = FactoryGirl.build :adm_tep, {:student => stu, :program => stu.adm_tep.first.program}
    assert_not second_app.valid?
  end

  test "scope open" do
    app = FactoryGirl.create :admitted_student
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
    app = FactoryGirl.build :adm_tep, {:student => nil,
      :program => nil,
      :banner_term => nil
    }
    # app.Student.id = nil
    # app.Program_ProgCode = nil
    # app.BannerTerm_BannerTerm = nil
    app.valid?
    assert_equal(app.errors[:student_id], ["No student selected."])
    assert_equal(app.errors[:Program_ProgCode], ["No program selected."])
    assert_equal(app.errors[:BannerTerm_BannerTerm], ["No term could be determined."])
  end

  test "admit date empty" do
    #tests validation for required admission date for accespted applications.
    # app = FactoryGirl.build :adm_tep, {:banner_term => FactoryGirl.create(:banner_term)}
    # app.TEPAdmit = true
    # letter = attach_letter(app)
    # app.TEPAdmitDate = nil
    # pop_transcript(app.student, 12, 3.0, app.banner_term.prev_term)

    stu = FactoryGirl.create :admitted_student
    app = stu.adm_tep.first
    app.TEPAdmitDate = nil
    app.valid?
    assert_equal(app.errors[:TEPAdmitDate], ["Admission date must be given."])

  end

  test "admit date too early" do
    # app = FactoryGirl.build :adm_tep, {:banner_term => FactoryGirl.create(:banner_term)}
    # date = app.banner_term.StartDate.to_date
    # app.TEPAdmitDate = date - 10
    # letter = attach_letter(app)
    # pop_transcript(app.student, 12, 3.0, app.banner_term.prev_term)
    stu = FactoryGirl.create :admitted_student
    app = stu.adm_tep.first
    app.TEPAdmitDate = app.banner_term.prev_term(exclusive = true).EndDate
    app.valid?
    assert_equal(app.errors[:TEPAdmitDate], ["Admission date must be after term begins."])
  end

  test "admit date too late" do
    stu = FactoryGirl.create :admitted_student
    app = stu.adm_tep.first
    app.TEPAdmitDate = app.banner_term.next_term(exclusive = true).EndDate
    app.valid?
    assert_equal(app.errors[:TEPAdmitDate], ["Admission date must be before next term begins."])

  end

  test "gpa both bad" do
    app = FactoryGirl.build :adm_tep, {:banner_term => FactoryGirl.create(:banner_term)}
    app.TEPAdmit = true
    letter = attach_letter(app)
    pop_transcript(app.student, 12, 2.0, app.banner_term.prev_term)
    app.valid?
    assert_includes app.errors[:base], "Student does not have sufficient GPA to be admitted this term."
  end


  [:GPA, :GPA_last30].each do |attr|
    test "Just #{attr} bad" do

      stu = FactoryGirl.create :admitted_student
      app = stu.adm_tep.first
      app.assign_attributes({attr => 1.0})
      app.valid?
      assert_equal(app.errors[:base], [])

    end
  end

  # test "overall gpa bad only" do
  #   app = FactoryGirl.build :adm_tep, {:banner_term => FactoryGirl.create(:banner_term)}
  #   pop_transcript(app.student, 12, 3.0, app.banner_term.prev_term)
  #   app.TEPAdmit = true
  #   app.valid?
  #   assert_equal(app.errors[:base], [])
  # end
  #
  # test "last 30 gpa bad only" do
  #
  #   stu = FactoryGirl.create :admitted_student
  #   app = stu.adm_tep.first
  #   app.GPA_last30 = 2.99
  #   app.valid?
  #   assert_equal(app.errors[:base], [])
  # end

  test "earned credits bad" do

    app = FactoryGirl.build :adm_tep, {:banner_term => FactoryGirl.create(:banner_term)}
    app.TEPAdmit = true
    letter = attach_letter(app)
    pop_transcript(app.student, 1, 3.0, app.banner_term.prev_term)
    app.valid?
    assert_equal(app.errors[:EarnedCredits], ["Student needs to have earned 30 credit hours and has only earned #{app.EarnedCredits}."])
  end

  test "already enrolled" do
    #student can't be admitted because they are already enrolled
    stu = FactoryGirl.create :admitted_student
    app = stu.adm_tep.first
    app2 = FactoryGirl.build :adm_tep, {:student => stu,
      :program => app.program,
      :banner_term => app.banner_term}

    app2.valid?
    assert_equal(app2.errors[:base], ["Student has already been admitted or has an open application for this program in this term."])
  end

  test "app already pending" do
    #student already has a pending app for this program
    stu = FactoryGirl.create :student
    prior_term = FactoryGirl.create :banner_term, {:BannerTerm => 2,
      :StartDate => 10.days.ago,
      :EndDate => 10.days.from_now
    }

    apply_term = FactoryGirl.create :banner_term, {:BannerTerm => 3,
      :StartDate => 20.days.from_now,
      :EndDate => 40.days.from_now
    }
    pop_transcript(stu, 12, 4.0, prior_term)

    app = FactoryGirl.create :adm_tep, {:student => stu,
      :banner_term => apply_term,
      :TEPAdmitDate => nil,
      :TEPAdmit => nil
    }

    app2 = FactoryGirl.build :adm_tep, {
      :student => stu,
      :banner_term => apply_term,
      :program  => app.program

    }

    app2.valid?
    assert_includes app2.errors[:base], "Student has already been admitted or has an open application for this program in this term."

  end

  test "didn't pass praxis I" do
    stu = FactoryGirl.create :student
    admit_term = FactoryGirl.create :banner_term
    app = FactoryGirl.build :adm_tep, {:student => stu,
      :banner_term => admit_term,
      :TEPAdmitDate => admit_term.StartDate,
      :TEPAdmit => true,
    }
    assert_not app.valid?
    assert ["Student has not passed the Praxis I exam."], app.errors[:base]

  end

  describe "completed foudationals" do

    before do
      @app = FactoryGirl.build :pending_adm_tep
      @stu = @app.student
      @prog = @app.program
    end


    test "returns false, no 150 grade" do
      assert_equal false, @app.completed_foundationals?
    end

    test "returns false, bad 150 grade" do
      FactoryGirl.create :transcript, {
        :student => @stu,
        :course_code => "EDS150",
        :grade_pt => 1.7
      }

      assert_equal false, @app.completed_foundationals?
    end

    progs = [
      {:prog_code => "14", :course_code => "EDS227"},
      {:prog_code => "3", :course_code => "EDS228"}
    ]

    # tests for p5 and secondary, but not music or pe
    progs.each do |prog|

      describe "with prog_code = #{prog[:prog_code]}" do

        before do
          FactoryGirl.create :transcript, {
            :student => @stu,
            :course_code => "EDS150",
            :grade_pt => 2.7
          }

          @prog.ProgCode = prog[:prog_code]
          @prog.save!
        end

        test "should return true" do
          FactoryGirl.create :transcript, {
            :student => @stu,
            :course_code => prog[:course_code],
            :grade_pt => 2.7
          }

          assert @app.completed_foundationals?
        end

        test "should return false - bad grade" do
          FactoryGirl.create :transcript, {
            :student => @stu,
            :course_code => prog[:course_code],
            :grade_pt => 2.3
          }
            assert_equal false, @app.completed_foundationals?
        end

        test "should return false - no grade" do
          assert_equal false, @app.completed_foundationals?
        end

      end # inner describe


      ['28', '40', '23'].each do |prog_code|
        describe "not implemented programs" do

          test "prog_code = #{prog_code}" do
            @prog.ProgCode = prog_code
            @prog.save!

            assert_raise NotImplementedError do
              @app.completed_foundationals?
            end
          end

        end
      end

    end # loop

  end

  describe "meet_foundationals" do
    # function called before_create to validate

    before do

      @app = FactoryGirl.build :pending_adm_tep, {
        :TEPAdmit => true,
        :TEPAdmitDate => Date.today
      }
      12.times.map {|i| FactoryGirl.create(:transcript, {
        :student => @app.student,
        :credits_attempted => 4.0,
        :credits_earned => 4.0,
        :gpa_include => true,
        :term_taken => @app.banner_term.prev_term(exclusive=true).id,
        :grade_pt => 4.0,
        :grade_ltr => "A",
        :course_code => "EDS10#{i}"
        })
      }
    end

    describe "requirement met" do

      before do
        FactoryGirl.create :transcript, {
          :student => @app.student,
          :credits_attempted => 4.0,
          :credits_earned => 4.0,
          :gpa_include => true,
          :term_taken => @app.banner_term.prev_term(exclusive=true).id,
          :grade_pt => 4.0,
          :grade_ltr => "A",
          :course_code => "EDS150"
        }
      end

      [{prog_code: "14", course: "EDS227"}, {prog_code: "99", course: "EDS228"}].each do |data|
        test "for prog: #{data[:prog_code]}" do
          FactoryGirl.create :transcript, {
            :student => @app.student,
            :credits_attempted => 4.0,
            :credits_earned => 4.0,
            :gpa_include => true,
            :term_taken => @app.banner_term.prev_term(exclusive=true).id,
            :grade_pt => 4.0,
            :grade_ltr => "A",
            :course_code => data[:course]
          }

          prog = @app.program
          prog.ProgCode = data[:prog_code]
          prog.save!
          assert @app.valid?
        end
      end

    end

    test "requirement not met" do

      assert_not @app.valid?
      assert  @app.errors[:base].include? "Student has not satisfied a foundational course."

    end

    test "valid for unimplemented program" do
      # music, pe, health
      prog = @app.program
      prog.ProgCode = "28"
      prog.save!

      assert @app.valid?, @app.errors.full_messages

    end

  end

end

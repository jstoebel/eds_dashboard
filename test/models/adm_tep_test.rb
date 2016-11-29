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
      :student_file => stu_file,
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
      first_adm_tep = FactoryGirl.build :adm_tep, {:program => program,
        :banner_term => term,
        :TEPAdmit => nil,
        :TEPAdmitDate => nil,
        :student_file => nil
      }
      first_adm_tep.save!
      second_adm_tep = FactoryGirl.build :adm_tep, {:program => program,
        :TEPAdmit => false,
        :TEPAdmitDate => nil,
        :student_file => nil
      }
      assert_not second_adm_tep.valid?
    end # test 
  end # describe
    
    # @app = Factory.new({:student_id => stu.id, 
    #   :Program_ProgCode => program, 
    #   :BannerTerm_BannerTerm => banner, 
    #   :student_file_id => stu_file.id,
    #   :TEPAdmit => false
    #   })
    # assert @app.valid?, app.errors.full_messages
    # assert_equal(app.errors[:Program_ProgCode], ["Student must not be admitted to the same program more than once."])
  
  # describe "multiple applications" do
    
  #   before do
  #     stu = FactoryGirl.create :admitted_student
  #     program = stu.adm_tep.first.program.id
  #     banner = BannerTerm.first.id
  #     @app_skeleton = FactoryGirl.attributes_for :adm_tep, {:student_id => stu.id, 
  #     :Program_ProgCode => program, 
  #     :BannerTerm_BannerTerm => banner, 
  #     :student_file_id => (FactoryGirl.build :student_file).id
  #     }
  #   end
    
  #   [true, false, nil].each do |second_result|
  #       test "second application: #{second_result.to_s}" do
          
  #         @app_skeleton.merge!({:TEPAdmit => second_result})
  #         AdmTep.attributes_for @app_skeleton
          
  #         if second_result == true 
  #           assert_not app.valid?, app.errors.full_messages
  #           assert_equal(app.errors[:Program_ProgCode], ["Student must not be admitted to the same program more than once."])
  #         elsif second_result == false
  #           assert app.valid?
  #         elsif second_result ==  nil
  #           assert_not app.valid?, app.errors.full_messages
  #           assert_equal(app.errors[:Program_ProgCode], ["Student must not be admitted to the same program more than once."])
  #         end
  #           # alter app to the state you need (hint use second_result)
  #           # make your assertions (they will differ based on what second_result is)
  #       end
  #   end
    
  # end
  
  # test "Same Programs for AdmTep" do 
  #   stu = FactoryGirl.create :admitted_student
  #   program = stu.adm_tep.first.program.id
  #   banner = BannerTerm.first.id
  #   app = FactoryGirl.build :adm_tep, {:student_id => stu.id, :Program_ProgCode => program, :BannerTerm_BannerTerm => banner}
  #   assert_not app.valid?, app.errors.full_messages
  #   assert_equal(app.errors[:Program_ProgCode], ["Student must not be admitted to the same program more than once."])
  # end

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
    second_app = FactoryGirl.build :adm_tep, {:student_id => stu.id, :Program_ProgCode => stu.adm_tep.first.id}
    assert_not second_app.valid?
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
    app = AdmTep.first
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

  test "gpa both bad" do
    app = AdmTep.where(TEPAdmit: true).first
    letter = attach_letter(app)
    pop_transcript(app.student, 12, 2.0, app.banner_term.prev_term)
    app.valid?
    assert (app.errors[:base].include? "Student does not have sufficent GPA to be admitted this term.")
  end

  test "overall gpa bad only" do
    app = AdmTep.first
    pop_transcript(app.student, 12, 3.0, app.banner_term.prev_term)
    app.TEPAdmit = true
    app.valid?
    assert_equal(app.errors[:base], [])
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

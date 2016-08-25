# == Schema Information
#
# Table name: prog_exits
#
#  id                :integer          not null, primary key
#  student_id        :integer          not null
#  Program_ProgCode  :integer          not null
#  ExitCode_ExitCode :integer          not null
#  ExitTerm          :integer          not null
#  ExitDate          :datetime
#  GPA               :float(24)
#  GPA_last60        :float(24)
#  RecommendDate     :datetime
#  Details           :text(65535)
#

FactoryGirl.define do

  factory :prog_exit do

      ExitCode_ExitCode "1849"
      GPA 3.0
      GPA_last60 3.0
      ExitDate Date.today
      RecommendDate Date.today

  end

  factory :successful_prog_exit, :class => 'ProgExit' do

      student
      Program_ProgCode {Program.first.id}
      ExitCode_ExitCode {ExitCode.find_by(:ExitCode => "1849").id}
      ExitTerm {(BannerTerm.current_term({:exact => false, :plan_b => :back})).id}
      ExitDate {(BannerTerm.current_term({:exact => false, :plan_b => :back})).EndDate}
      RecommendDate {(BannerTerm.current_term({:exact => false, :plan_b => :back})).EndDate}

      after(:build){ |exit|
        # create course work
        stu = exit.student

        courses = FactoryGirl.create_list :transcript, 12, {:student_id => stu.id,
          :grade_pt => 4.0,
          :grade_ltr => "A",
          :credits_earned =>  4.0,
          :term_taken => exit.banner_term.prev_term.id,
          :gpa_include => true
        }
      }

      after(:build){ |exit|
        stu = exit.student
        test_term = exit.banner_term.prev_term
        date_taken = test_term.StartDate
        p1_tests = PraxisTest.where({:TestFamily => 1, :CurrentTest => true})

        praxis_attrs = p1_tests.map { |test|
          FactoryGirl.attributes_for :praxis_result, {
            :student_id => stu.id,
            :praxis_test_id =>  test.id,
            :test_score => 101,
            :test_date => date_taken,
            :reg_date => date_taken
          }
        }

        praxis_attrs.map { |t| PraxisResult.create t }

      }
      after(:build) { |exit|
        FactoryGirl.create :adm_tep, {:student_id => exit.student.id,
          :Program_ProgCode => exit.program.id,
          :BannerTerm_BannerTerm => exit.banner_term.id,
          :TEPAdmitDate => (exit.ExitDate - 1)
        }
      }

      after(:build){|exit|
        stu = exit.student
        stu.EnrollmentStatus = "Graduation"
        stu.save!
      }
  end
end

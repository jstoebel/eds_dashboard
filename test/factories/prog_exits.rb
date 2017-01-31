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

      # ExitCode_ExitCode "1849"
      ExitCode_ExitCode { (FactoryGirl.create :exit_code, {:id => 1849, :ExitCode => "1849"}).id }
      GPA 3.0
      GPA_last60 3.0
      ExitDate Date.today
      RecommendDate Date.today

  end

  factory :successful_prog_exit, :class => 'ProgExit' do
      student
      program
      banner_term { FactoryGirl.create :banner_term, {:StartDate => 10.days.ago,
          :EndDate => 10.days.from_now}
      }
      ExitCode_ExitCode { (FactoryGirl.create :exit_code, {:id => 1849, :ExitCode => "1849"}).id }
      ExitDate {Date.today}
      RecommendDate {Date.today}

      after(:build){ |prog_exit|
        # create course work
        stu = prog_exit.student
        courses = FactoryGirl.create_list :transcript, 12, {:student_id => stu.id,
          :grade_pt => 4.0,
          :grade_ltr => "A",
          :credits_earned =>  1.0,
          :credits_attempted => 1.0,
          :term_taken => prog_exit.banner_term.prev_term.id,
          :gpa_include => true
        }
      }

      after(:build){ |prog_exit|
        stu = prog_exit.student
        test_term = prog_exit.banner_term.prev_term
        date_taken = test_term.StartDate
        p1_tests = PraxisTest.where({:TestFamily => 1, :CurrentTest => true})

        praxis_attrs = p1_tests.map { |test|
          FactoryGirl.attributes_for :praxis_result, {
            :student_id => stu.id,
            :praxis_test_id =>  test.id,
            :test_score => test.CutScore,
            :test_date => date_taken,
            :reg_date => date_taken
          }
        }

        praxis_attrs.map { |t| PraxisResult.create t }

      }
      after(:build) { |prog_exit|
        FactoryGirl.create :adm_tep, {:student_id => prog_exit.student.id,
          :Program_ProgCode => prog_exit.program.id,
          :BannerTerm_BannerTerm => prog_exit.banner_term.id,
          :TEPAdmitDate => (prog_exit.banner_term.StartDate)
        }
      }

      after(:build){|prog_exit|
        stu = prog_exit.student
        stu.EnrollmentStatus = "Graduation"
      }

      # after(:create) do |prog_exit|
      #   stu = prog_exit.student
      #   puts stu.gpa({term: prog_exit.banner_term.prev_term.id})
      #
      #   prog_exit.update_attributes!({:ExitDate => prog_exit.banner_term.EndDate,
      #     :RecommendDate => prog_exit.banner_term.EndDate
      #   })
      # end
  end
end

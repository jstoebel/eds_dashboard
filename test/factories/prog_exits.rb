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

      after(:build) { |prog_exit|
        stu = prog_exit.student
        FactoryGirl.create :accepted_adm_tep, {
          :student => stu,
          :program => prog_exit.program
        }

      }
      
      after(:build){|prog_exit|
        stu = prog_exit.student
        stu.EnrollmentStatus = "Graduation"
      }

  end
end

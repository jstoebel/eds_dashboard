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

FactoryGirl.define do
  factory :adm_tep do
    association :student    #links to student object factory
    # association :program
    # association :banner_term
    # need to provide Program_ProgCode
    # need to provide BannerTerm_BannerTerm
    program
    banner_term
    Attempt 1
    TEPAdmit true
    TEPAdmitDate Date.today
    GPA 2.75
    GPA_last30 3.0
    EarnedCredits 30

    factory :pending_adm_tep do
      TEPAdmit nil
      TEPAdmitDate nil
    #   adm_file nil
    end

    factory :accepted_adm_tep do
      TEPAdmit true
      after(:build) do |app|
        app.TEPAdmitDate = app.banner_term.StartDate
      end # admit date

      after(:build) do |app|
          # student needs to pass the praxis
          p1_tests = PraxisTest.where({:TestFamily => 1, :CurrentTest => true})
          p1_tests.each do |test|
              FactoryGirl.create :praxis_result, {
                  :student => app.student,
                  :praxis_test => test,
                  :test_score => (test.CutScore + 1)
              }
          end
      end # pass praxis

      after(:build) do |app|

          # pass foundationals reguardless of program
          ["EDS150", "EDS227", "EDS228"].each do |course_code|

            FactoryGirl.create :transcript, {
              :student => app.student,
              :credits_attempted => 4.0,
              :credits_earned => 4.0,
              :gpa_include => true,
              :term_taken => app.banner_term.prev_term(exclusive=true).id,
              :grade_pt => 4.0,
              :grade_ltr => "A",
              :course_code => course_code
            }

          end

          # 9 more courses
          courses = 9.times.map {|i| FactoryGirl.build(:transcript, {
              :student_id => app.student.id,
              :credits_attempted => 4.0,
              :credits_earned => 4.0,
              :gpa_include => true,
              :term_taken => app.banner_term.prev_term(exclusive=true).id,
              :grade_pt => 4.0,
              :grade_ltr => "A"
            })
          }

          courses.each { |i| i.save}
      end # gpa and credits

      after(:create) do |app|
          # need to associate a file with this app
          adm_file = AdmFile.create!({
              :adm_tep_id => app.id,
              :student_file => (FactoryGirl.create :student_file, {:student => app.student})
          })
      end

    end

  end
end

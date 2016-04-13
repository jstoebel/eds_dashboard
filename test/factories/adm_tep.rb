FactoryGirl.define do
  factory :adm_tep do
    sequence(:id) { |i| i }
    association :student, factory: :student
    Program_ProgCode Program.first.id
    BannerTerm_BannerTerm BannerTerm.current_term.id
    Attempt 1
    TEPAdmit true
    TEPAdmitDate Date.today
    GPA 2.75
    GPA_last30 3.0 
    EarnedCredits 30
    association :student_file, factory: :student_file
  end
end
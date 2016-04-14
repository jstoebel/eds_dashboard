FactoryGirl.define do
  factory :adm_tep do
    sequence(:id) { |i| i }
    association :student, factory: :prospective
    # need to provide Program_ProgCode
    # need to provide BannerTerm_BannerTerm
    Attempt 1
    TEPAdmit true
    TEPAdmitDate Date.today
    GPA 2.75
    GPA_last30 3.0 
    EarnedCredits 30
    association :student_file, factory: :student_file
  end
end
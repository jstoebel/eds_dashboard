FactoryGirl.define do
  factory :adm_st do

    #make the adm_st for the same student who has this adm_tep!
    # need to provide Bnum
    #need to provide the BannerTerm_BannerTerm
    Attempt 1
    STAdmitted true
    STAdmitDate Date.today
    OverallGPA 2.75
    CoreGPA 3.0
    association :student_file, factory: :student_file
  end
end
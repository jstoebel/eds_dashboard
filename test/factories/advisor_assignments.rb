FactoryGirl.define do
    factory :advisor_assignment do
        association :student, factory: :student
        association :tep_advisor, factory: :tep_advisor
    end 
end
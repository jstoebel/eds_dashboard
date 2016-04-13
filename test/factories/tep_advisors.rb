FactoryGirl.define do
  factory :tep_advisor do
    sequence(:AdvisorBnum) { |b| "B#{b.to_s.rjust(6, '0')}" }
    Salutation Faker::Name.first_name
    association :user, factory: :advisor
  end
end
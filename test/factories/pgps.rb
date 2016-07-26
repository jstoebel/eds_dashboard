# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pgp do
    association :student
    goal_name {"#{Faker::Name.name}"}
    description {"#{Faker::Name.name}"}
    plan {"#{Faker::Name.name}"}
  end
end

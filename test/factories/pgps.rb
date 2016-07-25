# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pgp do
    association :student
    goal_name "Goal here!"
    description "descrip here!"
    plan "plan here!"
  end
end

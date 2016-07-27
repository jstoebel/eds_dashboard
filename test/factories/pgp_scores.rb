include Faker
FactoryGirl.define do
  factory :pgp_score do
    association :pgp
    goal_score {Faker::Number.between(1,4)}
    score_reason "descrip here!"
  end
end

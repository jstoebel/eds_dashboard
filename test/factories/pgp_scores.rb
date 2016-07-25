include Faker
FactoryGirl.define do
  factory :pgp_score do
    association :pgp
    goal 2
    score_reason "descrip here!"
  end
end

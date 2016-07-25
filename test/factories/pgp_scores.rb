FactoryGirl.define do
  factory :pgp_score do
    pgp
    goal_score 2
    score_reason "descrip here!"
  end
end

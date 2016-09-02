# == Schema Information
#
# Table name: pgp_scores
#
#  id           :integer          not null, primary key
#  pgp_id       :integer
#  goal_score   :integer
#  score_reason :text(65535)
#  created_at   :datetime
#  updated_at   :datetime
#

include Faker
FactoryGirl.define do
  factory :pgp_score do
    association :pgp
    goal_score {Faker::Number.between(1,4)}
    score_reason "descrip here!"
  end
end

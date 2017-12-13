# == Schema Information
#
# Table name: pgp_scores
#
#  id          :integer          not null, primary key
#  pgp_goal_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :pgp_score do
    pgp_goal
    student
    item_level
    scored_at { Faker::Date.between(2.days.ago, Date.today) }
  end
end

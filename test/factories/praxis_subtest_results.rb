# == Schema Information
#
# Table name: praxis_subtest_results
#
#  id               :integer          not null, primary key
#  praxis_result_id :integer          not null
#  sub_number       :integer
#  name             :string(255)
#  pts_earned       :integer
#  pts_aval         :integer
#  avg_high         :integer
#  avg_low          :integer
#
include Faker
FactoryGirl.define do
  factory :praxis_subtest_result do
    praxis_result
    sub_number 1
    name {[Hacker.ingverb, Hacker.adjective, Hacker.noun].join(' ')}
    pts_aval 200
    pts_earned {Number.between(100, 200)}
    avg_high {Number.between(150, 200)}
    avg_low {Number.between(100, 149)}
  end
end

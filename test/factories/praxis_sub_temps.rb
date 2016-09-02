# == Schema Information
#
# Table name: praxis_sub_temps
#
#  id                    :integer          not null, primary key
#  praxis_result_temp_id :integer          not null
#  sub_number            :integer
#  name                  :string(255)
#  pts_earned            :integer
#  pts_aval              :integer
#  avg_high              :integer
#  avg_low               :integer
#

include Faker
FactoryGirl.define do
  factory :praxis_sub_temp do
    association :praxis_result_temp
    sub_number {1}
    name {Book.title}
    pts_earned {Number.between(1, 20)}
    pts_aval {20}
    avg_high {Number.between(10, 20)}
    avg_low {Number.between(1, 10)}
  end
end

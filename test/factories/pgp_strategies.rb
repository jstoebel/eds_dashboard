# == Schema Information
#
# Table name: pgp_strategies
#
#  id          :integer          not null, primary key
#  pgp_goal_id :integer
#  name        :string(255)
#  timeline    :text(65535)
#  resources   :text(65535)
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
include Faker
FactoryGirl.define do
  factory :pgp_strategy do
    pgp_goal
    name { Lorem.sentence }
    timeline { Lorem.paragraph }
    resources { Lorem.paragraph }
    active true
  end
end

# == Schema Information
#
# Table name: pgps
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  goal_name   :string(255)
#  description :text(65535)
#  plan        :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#  strategies  :text(65535)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :pgp do
    association :student

    goal_name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    plan { Faker::Lorem.paragraph }
    strategies { Faker::Lorem.paragraph }
  end
end

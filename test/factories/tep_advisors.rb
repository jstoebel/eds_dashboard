# == Schema Information
#
# Table name: tep_advisors
#
#  id          :integer          not null, primary key
#  AdvisorBnum :string(9)        not null
#  Salutation  :string(45)       not null
#  user_id     :integer
#  first_name  :string(255)      not null
#  last_name   :string(255)      not null
#

include Faker
FactoryGirl.define do
  factory :tep_advisor do
    sequence(:AdvisorBnum) {"B00#{Number.number(6)}"}
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    Salutation {first_name}
    association :user, factory: :advisor
  end
end

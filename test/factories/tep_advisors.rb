# == Schema Information
#
# Table name: tep_advisors
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  AdvisorBnum :string(9)        not null
#  Salutation  :string(255)
#  user_id     :integer
#

include Faker
FactoryGirl.define do
  factory :tep_advisor do
    sequence(:AdvisorBnum) {"B00#{Number.number(6)}"}
    Salutation {Faker::Name.first_name}
    association :user, factory: :advisor
  end
end

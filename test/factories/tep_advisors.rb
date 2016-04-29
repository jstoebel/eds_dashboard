# == Schema Information
#
# Table name: tep_advisors
#
#  id          :integer          not null, primary key
#  AdvisorBnum :string(9)        not null
#  Salutation  :string(45)       not null
#  user_id     :integer          not null
#
# Indexes
#
#  AdvisorBnum_UNIQUE       (AdvisorBnum) UNIQUE
#  tep_advisors_user_id_fk  (user_id)
#

FactoryGirl.define do
  factory :tep_advisor do
    sequence(:AdvisorBnum) { |b| "B#{b.to_s.rjust(6, '0')}" }
    Salutation Faker::Name.first_name
    association :user, factory: :advisor
  end
end

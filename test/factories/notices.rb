# == Schema Information
#
# Table name: notices
#
#  id         :integer          not null, primary key
#  message    :text(65535)      not null
#  active     :boolean          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :notice do
    message "an announcement"
    active true
  end
end

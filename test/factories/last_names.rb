# == Schema Information
#
# Table name: last_names
#
#  id         :integer          not null, primary key
#  student_id :integer
#  last_name  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :last_name do
  end
end

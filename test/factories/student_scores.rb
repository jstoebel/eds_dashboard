# == Schema Information
#
# Table name: student_scores
#
#  id            :integer          not null, primary key
#  student_id    :integer
#  item_level_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

=begin
=end

include Faker
FactoryGirl.define do
  factory :student_score do
    student
    item_level
  end
end

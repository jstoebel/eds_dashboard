# == Schema Information
#
# Table name: student_scores
#
#  id                    :integer          not null, primary key
#  student_id            :integer
#  assessment_version_id :integer
#  item_level_id         :integer
#  assessment_item_id    :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student_score do
    student
    assessment_version
    item_level
    assessment_item
  end
end

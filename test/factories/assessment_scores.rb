# == Schema Information
#
# Table name: assessment_scores
#
#  id                         :integer          not null, primary key
#  student_assessment_id      :integer          not null
#  assessment_item_version_id :integer          not null
#  score                      :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assessment_score do
    student_assessment
    assessment_item_version
  end
end

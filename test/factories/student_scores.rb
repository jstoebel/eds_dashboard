# == Schema Information
#
# Table name: student_scores
#
#  id                 :integer          not null, primary key
#  student_id         :integer          not null
#  assessment_version_id  :integer      not null
#  assessment_item_id :integer          not null
#  item_level_id      :integer          not null
#  created_at         :datetime
#  updated_at         :datetime
#

=begin
=end

include Faker
FactoryGirl.define do
  factory :student_score do
    student
    assessment_version
    assessment_item
    item_level
  end
end

# == Schema Information
#
# Table name: student_scores
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  item_level_id           :integer
#  scored_at               :datetime
#  created_at              :datetime
#  updated_at              :datetime
#  student_score_upload_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

=begin
=end

include Faker
FactoryGirl.define do
  factory :student_score do
    student
    item_level
    scored_at Date.today
  end
end

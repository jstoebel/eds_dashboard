# == Schema Information
#
# Table name: issues
#
#  student_id               :integer          not null
#  IssueID                  :integer          not null, primary key
#  Name                     :text             not null
#  Description              :text             not null
#  Open                     :boolean          default(TRUE), not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#  visible                  :boolean          default(TRUE), not null
#  positive                 :boolean
#

include Faker
FactoryGirl.define do
  factory :issue do
    association :student
    Name {Hipster.sentence}
    Description {Hipster.paragraph}
    Open true
    association :tep_advisor
    
  end
end

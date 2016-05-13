# == Schema Information
#
# Table name: issues
#
#  IssueID                  :integer          not null, primary key
#  student_id               :integer          not null
#  Name                     :text             not null
#  Description              :text             not null
#  Open                     :boolean          default(TRUE), not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
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

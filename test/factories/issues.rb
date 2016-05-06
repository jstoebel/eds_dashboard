# == Schema Information
#
# Table name: issues
#
#  IssueID                  :integer          not null, primary key
#  student_id               :integer          not null
#  Name                     :string(100)      not null
#  Description              :text             not null
#  Open                     :boolean          default(TRUE), not null
#  tep_advisors_AdvisorBnum :string(45)       not null
#  created_at               :datetime
#  updated_at               :datetime
#
include Faker
FactoryGirl.define do
  factory :issue do
    student
    Name {Hipster.sentence}
    Description {Hipster.paragraph}
    Open true
    tep_advisor
    
  end
end

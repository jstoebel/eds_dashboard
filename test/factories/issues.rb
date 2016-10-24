# == Schema Information
#
# Table name: issues
#
#  IssueID                  :integer          not null, primary key
#  student_id               :integer          not null
#  Name                     :text(65535)      not null
#  Description              :text(65535)      not null
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
    association :tep_advisor
    
    after(:create) do |issue|
      FactoryGirl.create :issue_update
    end

  end
end

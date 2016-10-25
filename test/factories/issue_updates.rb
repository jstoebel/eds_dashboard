# == Schema Information
#
# Table name: issue_updates
#
#  UpdateID                 :integer          not null, primary key
#  UpdateName               :text(65535)      not null
#  Description              :text(65535)      not null
#  Issues_IssueID           :integer          not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#  visible                  :boolean          default(TRUE), not null
#  addressed                :boolean
#  status                   :integer
#

FactoryGirl.define do
  factory :issue_update do
    association :issue
    UpdateName {Hipster.sentence}
    Description {Hipster.paragraph}
    status "concern"
    addressed false
  end
end

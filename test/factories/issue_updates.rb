# == Schema Information
#
# Table name: issue_updates
#
#  UpdateID                 :integer          not null, primary key
#  UpdateName               :text             not null
#  Description              :text             not null
#  Issues_IssueID           :integer          not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#

FactoryGirl.define do
  factory :issue_update do
    UpdateName {Hipster.sentence}
    Description {Hipster.paragraph}
    # issue
    # tep_advisor
  end
end

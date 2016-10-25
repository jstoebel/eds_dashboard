# == Schema Information
#
# Table name: issues
#
#  IssueID                  :integer          not null, primary key
#  student_id               :integer          not null
#  Name                     :text(65535)      not null
#  Description              :text(65535)      not null
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
      update_params = FactoryGirl.attributes_for :issue_update, {:Issues_IssueID => issue.id,
        :tep_advisors_AdvisorBnum => issue.tep_advisors_AdvisorBnum
      }
      update = IssueUpdate.create! update_params
    end


  end
end

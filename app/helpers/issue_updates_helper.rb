# == Schema Information
#
# Table name: issue_updates
#
#  UpdateID                 :integer          not null, primary key
#  UpdateName               :string(100)      not null
#  Description              :text             not null
#  Issues_IssueID           :integer          not null
#  tep_advisors_AdvisorBnum :string(45)       not null
#  created_at               :datetime
#  updated_at               :datetime
#
# Indexes
#
#  fk_IssueUpdates_Issues1_idx        (Issues_IssueID)
#  fk_IssueUpdates_tep_advisors1_idx  (tep_advisors_AdvisorBnum)
#

module IssueUpdatesHelper
end

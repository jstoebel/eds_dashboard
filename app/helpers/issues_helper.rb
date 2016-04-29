# == Schema Information
#
# Table name: issues
#
#  student_id               :integer          not null
#  IssueID                  :integer          not null, primary key
#  Name                     :string(100)      not null
#  Description              :text             not null
#  Open                     :boolean          default(TRUE), not null
#  tep_advisors_AdvisorBnum :string(45)       not null
#  created_at               :datetime
#  updated_at               :datetime
#
# Indexes
#
#  fk_Issues_tep_advisors1_idx  (tep_advisors_AdvisorBnum)
#  issues_student_id_fk         (student_id)
#

module IssuesHelper
end

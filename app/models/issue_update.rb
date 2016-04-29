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

class IssueUpdate < ActiveRecord::Base
	belongs_to :issue, foreign_key: 'Issues_IssueID'
	scope :sorted, lambda {order(:created_at => :desc)}

    BNUM_REGEX = /\AB00\d{6}\Z/i
	validates :UpdateName, 
		:length => { 
			maximum: 100,
			message: "Max name length is 100 characters."},
		presence: {message: "Please provide an update name."}

	validates :Description,
		presence: {message: "Please provide an update description."}

	validates :tep_advisors_AdvisorBnum,
		:presence => { message: "Please enter a valid B#, (including the B00)"}

	def student
		return self.issue.student
	end
end

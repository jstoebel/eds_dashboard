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

class IssueUpdate < ActiveRecord::Base
	belongs_to :issue, foreign_key: 'Issues_IssueID'
	belongs_to :tep_advisor, {:foreign_key => 'tep_advisors_AdvisorBnum'}


	scope :sorted, lambda {order(:created_at => :desc)}

    BNUM_REGEX = /\AB00\d{6}\Z/i
	validates :UpdateName, 
		presence: {message: "Please provide an update name."}

	validates :Description,
		presence: {message: "Please provide an update description."}

	validates :tep_advisors_AdvisorBnum,
		:presence => { message: "Could not find an advisor profile for this user."}

	def student
		return self.issue.student
	end
end

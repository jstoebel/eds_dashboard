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

class IssueUpdate < ActiveRecord::Base
	belongs_to :issue, foreign_key: 'Issues_IssueID'
	belongs_to :tep_advisor, {:foreign_key => 'tep_advisors_AdvisorBnum'}
	after_validation :add_addressed

	scope :sorted, lambda {order(:created_at => :desc)}

  BNUM_REGEX = /\AB00\d{6}\Z/i

	# the possible statuses for an issue update
	STATUSES = { resolved: {name: "resolved", status_color: :success, resolved: true},
							progressing: {name: "progressing", status_color: :warning, resolved: false},
							concern: {name: "concern", status_color: :danger, resolved: false}
	}

	validates :UpdateName,
		presence: {message: "Please provide an update name."}

	validates :Description,
		presence: {message: "Please provide an update description."}

	validates :tep_advisors_AdvisorBnum,
		presence: { message: "Could not find an advisor profile for this user."}

	validates :status,
		presence: { message: "Please select a status for this update"},
		inclusion: { in: STATUSES.keys.map(&:to_s), message: "Invalid status name"}

	def student
		return self.issue.student
	end

	def status_color
		return STATUSES[self.status.to_sym][:status_color]
	end

	private

	def add_addressed
		self.addressed = false if self.new_record?
	end

end

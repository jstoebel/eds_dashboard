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
#

class IssueUpdate < ActiveRecord::Base
	belongs_to :issue, foreign_key: 'Issues_IssueID'
	belongs_to :tep_advisor, {:foreign_key => 'tep_advisors_AdvisorBnum'}
	before_validation :add_addressed


	scope :sorted, lambda {order(:created_at => :desc)}

    BNUM_REGEX = /\AB00\d{6}\Z/i
	validates :UpdateName, 
		presence: {message: "Please provide an update name."}

	validates :Description,
		presence: {message: "Please provide an update description."}

	validates :tep_advisors_AdvisorBnum,
		:presence => { message: "Could not find an advisor profile for this user."}

	validate :has_addressed

	def student
		return self.issue.student
	end

	private

	def add_addressed
		self.addressed = true if self.new_record?
	end

	def has_addressed
		if !self.new_record? && self.addressed.nil?
			self.errors.add(:addressed, "update must have value for addressed.")
		end
	end

end

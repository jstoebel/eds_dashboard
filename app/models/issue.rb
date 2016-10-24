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

class Issue < ActiveRecord::Base
	belongs_to :student
	belongs_to :tep_advisor, {:foreign_key => 'tep_advisors_AdvisorBnum'}
	has_many :issue_updates, {:foreign_key => 'Issues_IssueID'}

	#SCOPES
	scope :sorted, lambda {order(:created_at => :desc)}
	scope :visible, lambda {where(:visible => true)}
	scope :open, lambda {where(:Open => true)}

	# HOOKS
	after_save :hide_updates

	validates :Name,
		presence: {message: "Please provide an issue name."}

	validates :Description,
		presence: {message: "Please provide an issue description."}

	validates :tep_advisors_AdvisorBnum,
		:presence => { message: "Could not find an advisor profile for this user."}

	def open
		return self.issue_updates.order(:created_at).last.open
	end

	private
	def hide_updates
		if self.visible == false
			updates = self.issue_updates
			updates.each do |f|
				f.visible = false
				f.save
			end
		end
	end

end

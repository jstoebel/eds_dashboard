# == Schema Information
#
# Table name: issues
#
#  IssueID                  :integer          not null, primary key
#  student_id               :integer          not null
#  Name                     :text             not null
#  Description              :text             not null
#  Open                     :boolean          default(TRUE), not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#

class Issue < ActiveRecord::Base
	belongs_to :student
	belongs_to :tep_advisor, {:foreign_key => 'tep_advisors_AdvisorBnum'}
	has_many :issue_updates, {:foreign_key => 'Issues_IssueID'}

	scope :sorted, lambda {order(:Open => :desc, :created_at => :desc)}

    # BNUM_REGEX = /\AB00\d{6}\Z/i
    # validates :student_id,
    # 	presence: {message: "Please enter a valid B#, (including the B00)"}

	validates :Name, 
		presence: {message: "Please provide an issue name."}

	validates :Description,
		presence: {message: "Please provide an issue description."}

	validates :Open,
		inclusion: {
			:in => [true, false],
			allow_blank: false,
			message: "Issue may only be open or closed."
			}

	validates :tep_advisors_AdvisorBnum,
		:presence => { message: "Please enter a valid B#, (including the B00)"}


end

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

class Issue < ActiveRecord::Base
	belongs_to :student
	has_many :issue_updates, {:foreign_key => 'Issues_IssueID'}

	scope :sorted, lambda {order(:Open => :desc, :created_at => :desc)}

    BNUM_REGEX = /\AB00\d{6}\Z/i
    validates :student_id,
    	presence: {message: "Please enter a valid B#, (including the B00)"}

	validates :Name, 
		:length => { 
			maximum: 100,
			message: "Max name length is 100 characters."},
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

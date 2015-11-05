class IssueUpdate < ActiveRecord::Base
	belongs_to :issue, foreign_key: 'Issues_IssueID'

	scope :sorted, lambda {order(:CreateDate => :desc)}

    BNUM_REGEX = /\AB00\d{6}\Z/i
	validates :UpdateName, 
		:length => { 
			maximum: 100,
			message: "Max name length is 100 characters."},
		presence: {message: "Please provide an update name."}

	validates :Description,
		presence: {message: "Please provide an update description."}

	validates :tep_advisors_AdvisorBnum,
		format: {
			with: BNUM_REGEX,
        	message: "Please enter a valid B#, (including the B00)",
        	allow_blank: false}
end

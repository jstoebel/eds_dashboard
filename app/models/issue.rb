class Issue < ActiveRecord::Base

	belongs_to :student, foreign_key: 'students_Bnum'
	has_many :issue_updates, {:foreign_key => 'Issues_IssueID'}

	scope :sorted, lambda {order(:Open => :desc, :CreateDate => :desc)}

    BNUM_REGEX = /\AB00\d{6}\Z/i
    validates :students_Bnum,
      format: {with: BNUM_REGEX,
        message: "Please enter a valid B#, (including the B00)",
        allow_blank: false}

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
		format: {with: BNUM_REGEX,
        message: "Please enter a valid B#, (including the B00)",
        allow_blank: false}


end

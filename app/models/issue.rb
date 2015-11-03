class Issue < ActiveRecord::Base

	belongs_to :student, foreign_key: 'students_Bnum'
	has_many :issue_updates, {:foreign_key => 'Issues_IssueID'}

    BNUM_REGEX = /\AB00\d{6}\Z/i
    validates :students_Bnum,
      format: {with: BNUM_REGEX,
        message: "Please enter a valid B#, (including the B00)",
        allow_blank: true}

	validates :Name, 
		:length => { maximum: 100},
		presence: true


	validates :Description,
		presence: true

	validates :Open,
		inclusion: {:in => [true, false]}

	validates :tep_advisors_AdvisorBnum,
		format: {with: BNUM_REGEX,
        message: "Please enter a valid B#, (including the B00)",
        allow_blank: true}

	scope :sorted, lambda {order(:Open => :desc, :CreateDate => :desc)}
end

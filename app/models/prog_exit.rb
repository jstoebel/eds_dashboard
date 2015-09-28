class ProgExit < ActiveRecord::Base

	belongs_to :student, foreign_key: "Student_Bnum"
	belongs_to :program, foreign_key: "Program_ProgCode"

	scope :by_term, ->(term) {where("ExitTerm = ?", term)}
end

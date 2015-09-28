class ProgExit < ActiveRecord::Base

	belongs_to :student
	belongs_to :programe	

	#implement scope by term
	scope :by_term, ->(term) {where("ExitTerm = ?", term)}
end

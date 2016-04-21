class AdvisorAssignment < ActiveRecord::Base
	self.primary_keys = :Student_Bnum, :tep_advisors_AdvisorBnum
	belongs_to :student
	belongs_to :tep_advisor
end

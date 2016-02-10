class AdvisorAssignment < ActiveRecord::Base
	self.primary_keys = :student, :tep_advisor
	belongs_to :student, {:foreign_key => 'Student_Bnum'}
	belongs_to :tep_advisor, {:foreign_key => 'tep_advisors_AdvisorBnum'}
end

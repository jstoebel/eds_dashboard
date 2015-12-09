class AdvisorAssignment < ActiveRecord::Base

	belongs_to :student, {:foreign_key => 'Student_Bnum'}
	belongs_to :tep_advisor, {:foreign_key => 'tep_advisors_AdvisorBnum'}
end

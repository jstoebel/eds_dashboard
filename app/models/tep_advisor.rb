class TepAdvisor < ActiveRecord::Base
	self.table_name = "tep_advisors"

	has_many :advisor_assignments, {:foreign_key => 'Student_Bnum'}
end

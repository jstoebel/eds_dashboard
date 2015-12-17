class TepAdvisor < ActiveRecord::Base
	self.table_name = "tep_advisors"

	has_many :advisor_assignments, {:foreign_key => 'tep_advisors_AdvisorBnum'}
	has_many :students, {:foreign_key => 'tep_advisors_AdvisorBnum', :through => :advisor_assignments}
	has_many :issues, {:foreign_key => 'tep_advisors_AdvisorBnum'}

	belongs_to :user, {:foreign_key => 'username'}
end

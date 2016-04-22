class AdvisorAssignment < ActiveRecord::Base
	belongs_to :student
	belongs_to :tep_advisor
end

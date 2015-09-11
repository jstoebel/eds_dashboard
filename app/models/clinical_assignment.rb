class ClinicalAssignment < ActiveRecord::Base

	belongs_to :student
	has_one :clinical_teacher, {:foreign_key => 'idClinicalTeacher'}
end

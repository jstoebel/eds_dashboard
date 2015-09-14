class ClinicalAssignment < ActiveRecord::Base

	belongs_to :student, {:foreign_key => 'Bnum'}
	belongs_to :clinical_teacher
end

class ClinicalTeacher < ActiveRecord::Base

	has_many :clinical_assignments
	belongs_to :clinical_site
end

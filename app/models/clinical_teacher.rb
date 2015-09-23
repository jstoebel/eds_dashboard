class ClinicalTeacher < ActiveRecord::Base

	has_many :clinical_assignments
	belongs_to :clinical_site

  	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
  	validates :Email, 
		:presence => true,
	    :format => EMAIL_REGEX

	validate do |teacher|
		teacher.errors.add(:base, "Please enter a first name.") if teacher.FirstName.blank?
		teacher.errors.add(:base, "Please enter a last name.") if teacher.LastName.blank?
		teacher.errors.add(:base, "Please select a subject.") if teacher.Subject.blank?
		teacher.errors.add(:base, "Please select a school") if teacher.clinical_site_id.blank?
		teacher.errors.add(:base, "Please enter a valid rank (1-3).") if not [1..3].include? teacher.Rank		
		teacher.errors.add(:base, "Please enter years of experience.") if teacher.YearsExp.blank?			
	end
end

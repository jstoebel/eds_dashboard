class ClinicalTeacher < ActiveRecord::Base

	has_many :clinical_assignments
	belongs_to :clinical_site

  	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
  	validates :FirstName,
  		:presence => {message: "Please enter a first name."}

  	validates :LastName,
  		:presence => {message: "Please enter a last name."}

    validates :Email, 
      :format => {with: EMAIL_REGEX, 
        message: "Please enter a valid email address."},
        allow_blank: true
        
  	validates :Subject,
  		:presence => {message: "Please enter a subject."}

  	validates :clinical_site_id,
  		:presence => {message: "Please enter a school."}

  	validates :Rank,
  		:numericality => {
			only_integer: true,
			greater_than: 0,
			less_than: 4,
			message: "Please enter a valid rank (1-3)."},
      allow_blank: true

  	validates :YearsExp,
  		:numericality => {only_integer: true, 
        message: "Years of experience must be an integer."},
      allow_blank: true



end

# == Schema Information
#
# Table name: clinical_teachers
#
#  id               :integer          not null, primary key
#  Bnum             :string(45)
#  FirstName        :string(45)       not null
#  LastName         :string(45)       not null
#  Email            :string(45)
#  Subject          :string(45)
#  clinical_site_id :integer          not null
#  Rank             :integer
#  YearsExp         :integer
#

class ClinicalTeacher < ActiveRecord::Base

	has_many :clinical_assignments
	belongs_to :clinical_site

    BNUM_REGEX = /\AB00\d{6}\Z/i
    validates :Bnum,
      format: {with: BNUM_REGEX,
        message: "Please enter a valid B#, (including the B00)",
        allow_blank: true}

  	validates :FirstName,
  		:presence => {message: "Please enter a first name."},
      :length => {maximum: 45, message: "First name max length is 45 characters."}

  	validates :LastName,
  		:presence => {message: "Please enter a last name."},
      :length => {maximum: 45, message: "Last name max length is 45 characters."}

    EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
    validates :Email, 
      :format => {with: EMAIL_REGEX, 
        message: "Please enter a valid email address.",
        allow_blank: true},
      :length => {maximum: 45, message: "Email max length is 45 characters."}
        
        
  	validates :Subject,
  		:presence => {message: "Please enter a subject."},
      :length => {maximum: 45, message: "Subject max length is 45 characters."}

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
  		:numericality => {greater_than: 0, 
        message: "Years of experience must be an positive integer."},
      allow_blank: true



end

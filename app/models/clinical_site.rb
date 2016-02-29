class ClinicalSite < ActiveRecord::Base
	has_many :clinical_teachers

	validates :SiteName,
		presence: { message: "Please enter a site name."}

	validates :City,
		presence: {message: "Please enter a city."}

	validates :County,
		presence: {message: "Please enter a county."}

	validates :District,
		presence: {message: "Please enter a district."}

	validates :phone,
		presnce: {message: "Please enter a phone number"}

	phony_normalize :phone, default_country_code: 'US'
	validates :phone, phony_plausible: true
	
	validates :email, 
		presence: {message: "Please enter an email."}, 
		format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, 
					message: "Please enter a valid email." }

	validates :receptionist,
		presence: {message: "Please enter a receptionist."}

	validates :website,
		presence: {message: "Please enter a school website."},
		format: {:with => URI::, message: "Please enter a valid school website."}


end

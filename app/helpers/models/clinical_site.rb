# == Schema Information
#
# Table name: clinical_sites
#
#  id           :integer          not null, primary key
#  SiteName     :string(45)       not null
#  City         :string(45)
#  County       :string(45)
#  Principal    :string(45)
#  District     :string(45)
#  phone        :string(255)
#  receptionist :string(255)
#  website      :string(255)
#  email        :string(255)
#

class ClinicalSite < ActiveRecord::Base
	has_many :clinical_teachers , dependent: :destroy

	validates :SiteName,
		presence: { message: "Please enter a site name."}

	validates :City,
		presence: {message: "Please enter a city."}

	validates :County,
		presence: {message: "Please enter a county."}

	validates :District,
		presence: {message: "Please enter a district."}

	validates :phone,
		presence: {message: "Please enter a phone number."},
		phony_plausible: {message: "Please enter a valid phone number."}

	validates :email,
		format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
					:allow_blank => true,
					message: "Please enter a valid email." }

	validates :receptionist,
		presence: {message: "Please enter a receptionist."}

	validates :website,
		presence: {message: "Please enter a school website."},
		format: {:with => /\./, message: "Please enter a valid website."}

	phony_normalize :phone, default_country_code: 'US'

end

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

	# validate do |site|
	# 	site.errors.add(:base, "Please enter a site name.") if site.SiteName.blank?
	# 	site.errors.add(:base, "Please enter a city.") if site.City.blank?
	# 	site.errors.add(:base, "Please enter a county.") if site.County.blank?
	# 	site.errors.add(:base, "Please enter a sistrict.") if site.District.blank?
	# end

end

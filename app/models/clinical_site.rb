class ClinicalSite < ActiveRecord::Base
	has_many :clinical_teachers

	validate do |site|
		site.errors.add(:base, "Please enter a site name.") if site.SiteName.blank?
		site.errors.add(:base, "Please enter a city.") if site.City.blank?
		site.errors.add(:base, "Please enter a county.") if site.County.blank?
		site.errors.add(:base, "Please enter a sistrict.") if site.District.blank?
	end

end

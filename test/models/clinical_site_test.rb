require 'test_helper'

class ClinicalSiteTest < ActiveSupport::TestCase

	test "needs site name" do
		site = ClinicalSite.first
		site.SiteName = nil
		site.valid?
		py_assert(["Please enter a site name."], site.errors[:SiteName])
	end

	test "needs city" do
		site = ClinicalSite.first
		site.City = nil
		site.valid?
		py_assert(["Please enter a city."], site.errors[:City])
	end

	test "needs county" do
		site = ClinicalSite.first
		site.County = nil
		site.valid?
		py_assert(["Please enter a county."], site.errors[:County])
	end

	test "needs district" do
		site = ClinicalSite.first
		site.District = nil
		site.valid?
		py_assert(["Please enter a district."], site.errors[:District])
	end
end

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

require 'test_helper'

class ClinicalSiteTest < ActiveSupport::TestCase

	test "needs site name" do
		site = ClinicalSite.first
		site.SiteName = nil
		site.valid?
		assert_equal(["Please enter a site name."], site.errors[:SiteName])
	end

	test "needs city" do
		site = ClinicalSite.first
		site.City = nil
		site.valid?
		assert_equal(["Please enter a city."], site.errors[:City])
	end

	test "needs county" do
		site = ClinicalSite.first
		site.County = nil
		site.valid?
		assert_equal(["Please enter a county."], site.errors[:County])
	end

	test "needs district" do
		site = ClinicalSite.first
		site.District = nil
		site.valid?
		assert_equal(["Please enter a district."], site.errors[:District])
	end

	test "needs phone" do
		site = ClinicalSite.first
		site.phone = nil
		site.valid?
		assert_equal ["Please enter a phone number."], site.errors[:phone]
	end

	test "phone number invalid" do
		site = ClinicalSite.first
		site.phone = "123"
		site.valid?
		assert_equal ["Please enter a valid phone number."], site.errors[:phone]
	end

	test "needs email" do
		site = ClinicalSite.first
		site.email = nil
		site.valid?
		assert_equal ["Please enter an email.", "Please enter a valid email."], site.errors[:email]
	end

	test "invalid email no username" do
		site = ClinicalSite.first
		site.email = "@berea.edu"
		site.valid?
		assert_equal ["Please enter a valid email."], site.errors[:email]
	end

	test "invalid email no domain" do
		site = ClinicalSite.first
		site.email = "feej"
		site.valid?
		assert_equal ["Please enter a valid email."], site.errors[:email]
	end

	test "invalid email no suffix" do
		site = ClinicalSite.first
		site.email = "feej@berea"
		site.valid?
		assert_equal ["Please enter a valid email."], site.errors[:email]
	end

	test "needs receptionist" do
		site = ClinicalSite.first
		site.receptionist = nil
		site.valid?
		assert_equal ["Please enter a receptionist."], site.errors[:receptionist]
	end 

	test "needs website" do
		site = ClinicalSite.first
		site.website = nil
		site.valid?
		assert_equal ["Please enter a school website.", "Please enter a valid website." ], site.errors[:website]
	end

	test "invalid website" do
		site = ClinicalSite.first
		site.website = "berea"
		site.valid?
		assert_equal ["Please enter a valid website." ], site.errors[:website]
	end	
end

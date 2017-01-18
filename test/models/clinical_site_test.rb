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
		site = FactoryGirl.create :clinical_site
		site.SiteName = nil
		site.valid?
		assert_equal(["Please enter a site name."], site.errors[:SiteName])
	end

	test "needs city" do
		site = FactoryGirl.create :clinical_site
		site.City = nil
		site.valid?
		assert_equal(["Please enter a city."], site.errors[:City])
	end

	test "needs county" do
		site = FactoryGirl.create :clinical_site
		site.County = nil
		site.valid?
		assert_equal(["Please enter a county."], site.errors[:County])
	end

	test "needs district" do
		site = FactoryGirl.create :clinical_site
		site.District = nil
		site.valid?
		assert_equal(["Please enter a district."], site.errors[:District])
	end

	test "needs phone" do
		site = FactoryGirl.create :clinical_site
		site.phone = nil
		site.valid?
		assert_equal ["Please enter a phone number."], site.errors[:phone]
	end

	test "phone number invalid" do
		site = FactoryGirl.create :clinical_site
		site.phone = "123"
		site.valid?
		assert_equal ["Please enter a valid phone number."], site.errors[:phone]
	end

	test "bad email" do
		site = FactoryGirl.create :clinical_site
		site.email = "not an email!"
		site.valid?
		assert_equal ["Please enter a valid email."], site.errors[:email]
	end

	test "allows blank email" do
		site = FactoryGirl.create :clinical_site
		site.email = nil
		assert site.valid?
		site.valid?
	end

	test "invalid email no username" do
		site = FactoryGirl.create :clinical_site
		site.email = "@berea.edu"
		site.valid?
		assert_equal ["Please enter a valid email."], site.errors[:email]
	end

	test "invalid email no domain" do
		site = FactoryGirl.create :clinical_site
		site.email = "feej"
		site.valid?
		assert_equal ["Please enter a valid email."], site.errors[:email]
	end

	test "invalid email no suffix" do
		site = FactoryGirl.create :clinical_site
		site.email = "feej@berea"
		site.valid?
		assert_equal ["Please enter a valid email."], site.errors[:email]
	end

	test "needs receptionist" do
		site = FactoryGirl.create :clinical_site
		site.receptionist = nil
		site.valid?
		assert_equal ["Please enter a receptionist."], site.errors[:receptionist]
	end

	test "needs website" do
		site = FactoryGirl.create :clinical_site
		site.website = nil
		site.valid?
		assert_equal ["Please enter a school website.", "Please enter a valid website." ], site.errors[:website]
	end

	test "invalid website" do
		site = FactoryGirl.create :clinical_site
		site.website = "berea"
		site.valid?
		assert_equal ["Please enter a valid website." ], site.errors[:website]
	end
end

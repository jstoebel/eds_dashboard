# == Schema Information
#
# Table name: clinical_teachers
#
#  id                  :integer          not null, primary key
#  Bnum                :string(45)
#  FirstName           :string(45)       not null
#  LastName            :string(45)       not null
#  Email               :string(45)
#  Subject             :string(45)
#  clinical_site_id    :integer          not null
#  Rank                :integer
#  YearsExp            :integer
#  begin_service       :datetime
#  epsb_training       :datetime
#  ct_record           :datetime
#  co_teacher_training :datetime
#

require 'test_helper'

class ClinicalTeacherTest < ActiveSupport::TestCase

	test "bnum matches regex1" do
		t = FactoryGirl.build :clinical_teacher, {:Bnum => "00123456"}
		t.valid?
		assert_equal(["Please enter a valid B#, (including the B00)"], t.errors[:Bnum])
	end

	test "bnum matches regex2" do
		t = FactoryGirl.build :clinical_teacher, {:Bnum => "B001234567"}
		t.valid?
		assert_equal(["Please enter a valid B#, (including the B00)"], t.errors[:Bnum])
	end

	test "bnum matches regex3" do
		t = FactoryGirl.build :clinical_teacher, {:Bnum => "123456"}
		t.valid?
		assert_equal(["Please enter a valid B#, (including the B00)"], t.errors[:Bnum])
	end

	test "bnum matches regex4" do
		t = FactoryGirl.build :clinical_teacher, {:Bnum => "B0012345"}
		t.valid?
		assert_equal(["Please enter a valid B#, (including the B00)"], t.errors[:Bnum])
	end

	test "bnum matches regex5" do
		t = FactoryGirl.build :clinical_teacher, {:Bnum => "completly off!"}
		t.valid?
		assert_equal(["Please enter a valid B#, (including the B00)"], t.errors[:Bnum])
	end

	test "blank bnum ok" do
		t = FactoryGirl.build :clinical_teacher, :Bnum => nil
		t.valid?
		assert_equal([], t.errors[:Bnum])
	end

	test "need first name" do
		t = FactoryGirl.build :clinical_teacher, :FirstName => nil
		t.valid?
		assert_equal(["Please enter a first name."], t.errors[:FirstName])
	end

	test "first name max length" do
		t = FactoryGirl.build :clinical_teacher, :FirstName => "a"*46
		t.valid?
		assert_equal(["First name max length is 45 characters."], t.errors[:FirstName])
	end

	test "need last name" do
		t = FactoryGirl.build :clinical_teacher, :LastName => nil
		t.valid?
		assert_equal(["Please enter a last name."], t.errors[:LastName])
	end

	test "last name max length" do
		t = FactoryGirl.build :clinical_teacher, :LastName => "a"*46
		t.valid?
		assert_equal(["Last name max length is 45 characters."], t.errors[:LastName])
	end

	test "email matches regex1" do
		t = FactoryGirl.build :clinical_teacher, :Email => 'firstname.lastname'
		t.valid?
		assert_equal(["Please enter a valid email address."], t.errors[:Email])
	end

	test "email matches regex2" do
		t = FactoryGirl.build :clinical_teacher, :Email => 'firstname.lastname@berea'
		t.valid?
		assert_equal(["Please enter a valid email address."], t.errors[:Email])
	end

	test "email matches regex3" do
		t = FactoryGirl.build :clinical_teacher, :Email => "first.last@madison.kyschools.us"
		t.valid?
		assert_equal([], t.errors[:Email])
	end

	test "blank email ok" do
		t = FactoryGirl.build :clinical_teacher, :Email => nil
		t.valid?
		assert_equal([], t.errors[:Email])
	end

	test "email length" do
		t = FactoryGirl.build :clinical_teacher, :Email => "a"*25 + "@madison.kyschools.us"
		t.valid?
		assert_equal(["Email max length is 45 characters."], t.errors[:Email])
	end

	test "need subject" do
		t = FactoryGirl.build :clinical_teacher, :Subject => nil
		t.valid?
		assert_equal(["Please enter a subject."], t.errors[:Subject])
	end

	test "subject length" do
		t = FactoryGirl.build :clinical_teacher, :Subject => Subject = "a"*46
		t.valid?
		assert_equal(["Subject max length is 45 characters."], t.errors[:Subject])
	end

	test "need site" do
		t = FactoryGirl.build :clinical_teacher, :clinical_site_id => nil
		t.valid?
		assert_equal(["Please enter a school."], t.errors[:clinical_site_id])
	end

	test "rank too low" do
		t = FactoryGirl.build :clinical_teacher, :Rank => 0
		t.valid?
		assert_equal(["Please enter a valid rank (1-3)."], t.errors[:Rank])
	end

	test "rank too high" do
		t = FactoryGirl.build :clinical_teacher, :Rank => 4
		t.valid?
		assert_equal(["Please enter a valid rank (1-3)."], t.errors[:Rank])
	end

	test "empty rank ok" do
		t = FactoryGirl.build :clinical_teacher, :Rank => nil
		t.valid?
		assert_equal([], t.errors[:Rank])
	end

	test "rank integer" do
		t = FactoryGirl.build :clinical_teacher, :Rank => 2.5
		t.valid?
		assert_equal(["Please enter a valid rank (1-3)."], t.errors[:Rank])
	end

	test "years experience number" do
		t = FactoryGirl.build :clinical_teacher, :YearsExp => "five"
		t.valid?
		assert_equal(["Years of experience must be an positive integer."], t.errors[:YearsExp])
	end

	test "years experience positive" do
		t = FactoryGirl.build :clinical_teacher, :YearsExp => -5
		t.valid?
		assert_equal(["Years of experience must be an positive integer."], t.errors[:YearsExp])
	end

	test "years experience blank ok" do
		t = FactoryGirl.build :clinical_teacher, :YearsExp => nil
		t.valid?
		assert_equal([], t.errors[:YearsExp])
	end

end

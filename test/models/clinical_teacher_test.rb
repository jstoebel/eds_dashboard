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
		t = ClinicalTeacher.first
		t.Bnum = "00123456"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Bnum])
	end

	test "bnum matches regex2" do
		t = ClinicalTeacher.first
		t.Bnum = "B001234567"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Bnum])
	end

	test "bnum matches regex3" do
		t = ClinicalTeacher.first
		t.Bnum = "123456"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Bnum])
	end

	test "bnum matches regex4" do
		t = ClinicalTeacher.first
		t.Bnum = "B0012345"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Bnum])
	end

	test "bnum matches regex5" do
		t = ClinicalTeacher.first
		t.Bnum = "completly off!"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:Bnum])
	end

	test "blank bnum ok" do
		t = ClinicalTeacher.first
		t.Bnum = nil
		t.valid?
		py_assert([], t.errors[:Bnum])		
	end

	test "need first name" do
		t = ClinicalTeacher.first
		t.FirstName = nil
		t.valid?
		py_assert(["Please enter a first name."], t.errors[:FirstName])
	end

	test "first name max length" do
		t = ClinicalTeacher.first
		t.FirstName = "a"*46
		t.valid?
		py_assert(["First name max length is 45 characters."], t.errors[:FirstName])
	end

	test "need last name" do
		t = ClinicalTeacher.first
		t.LastName = nil
		t.valid?
		py_assert(["Please enter a last name."], t.errors[:LastName])
	end

	test "last name max length" do
		t = ClinicalTeacher.first
		t.LastName = "a"*46
		t.valid?
		py_assert(["Last name max length is 45 characters."], t.errors[:LastName])
	end

	test "email matches regex1" do
		t = ClinicalTeacher.first
		t.Email = "jacob.stoebel"
		t.valid?
		py_assert(["Please enter a valid email address."], t.errors[:Email])
	end

	test "email matches regex2" do
		t = ClinicalTeacher.first
		t.Email = "jacob.stoebel@berea"
		t.valid?
		py_assert(["Please enter a valid email address."], t.errors[:Email])
	end

	test "email matches regex3" do
		t = ClinicalTeacher.first
		t.Email = "jacob.stoebel@madison.kyschools.us"
		t.valid?
		py_assert([], t.errors[:Email])
	end

	test "blank email ok" do
		t = ClinicalTeacher.first
		t.Email = nil
		t.valid?
		py_assert([], t.errors[:Email])
	end

	test "email length" do
		t = ClinicalTeacher.first
		t.Email = "a"*25 + "@madison.kyschools.us"
		t.valid?
		py_assert(["Email max length is 45 characters."], t.errors[:Email])
	end

	test "need subject" do
		t = ClinicalTeacher.first
		t.Subject = nil
		t.valid?
		py_assert(["Please enter a subject."], t.errors[:Subject])
	end

	test "subject length" do
		t = ClinicalTeacher.first
		t.Subject = "a"*46
		t.valid?
		py_assert(["Subject max length is 45 characters."], t.errors[:Subject])
	end

	test "need site" do
		t = ClinicalTeacher.first
		t.clinical_site_id = nil
		t.valid?
		py_assert(["Please enter a school."], t.errors[:clinical_site_id])
	end

	test "rank too low" do
		t = ClinicalTeacher.first
		t.Rank = 0
		t.valid?
		py_assert(["Please enter a valid rank (1-3)."], t.errors[:Rank])
	end

	test "rank too high" do
		t = ClinicalTeacher.first
		t.Rank = 4
		t.valid?
		py_assert(["Please enter a valid rank (1-3)."], t.errors[:Rank])
	end

	test "empty rank ok" do
		t = ClinicalTeacher.first
		t.Rank = nil
		t.valid?
		py_assert([], t.errors[:Rank])
	end

	test "rank integer" do
		t = ClinicalTeacher.first
		t.Rank = 2.5
		t.valid?
		py_assert(["Please enter a valid rank (1-3)."], t.errors[:Rank])
	end

	test "years experience number" do
		t = ClinicalTeacher.first
		t.YearsExp = "five"
		t.valid?
		py_assert(["Years of experience must be an positive integer."], t.errors[:YearsExp])
	end

	test "years experience positive" do
		t = ClinicalTeacher.first
		t.YearsExp = -5
		t.valid?
		py_assert(["Years of experience must be an positive integer."], t.errors[:YearsExp])
	end

	test "years experience blank ok" do
		t = ClinicalTeacher.first
		t.YearsExp = nil
		t.valid?
		py_assert([], t.errors[:YearsExp])
	end

end

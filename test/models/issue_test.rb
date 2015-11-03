require 'test_helper'

class IssueTest < ActiveSupport::TestCase


	#TESTS FOR STUDENT BNUM
	test "bnum matches regex1" do
		t = Issue.first
		t.students_Bnum = "00123456"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:students_Bnum])
	end

	test "bnum matches regex2" do
		t = Issue.first
		t.students_Bnum = "B001234567"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:students_Bnum])
	end

	test "bnum matches regex3" do
		t = Issue.first
		t.students_Bnum = "123456"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:students_Bnum])
	end

	test "bnum matches regex4" do
		t = Issue.first
		t.students_Bnum = "B0012345"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:students_Bnum])
	end

	test "bnum matches regex5" do
		t = Issue.first
		t.students_Bnum = "completly off!"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:students_Bnum])
	end

	test "blank bnum bad" do
		t = Issue.first
		t.students_Bnum = nil
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:students_Bnum])		
	end

	test "needs name" do
		t = Issue.first
		t.Name = nil
		t.valid?
		py_assert(["Please provide an issue name."], t.errors[:Name])
	end

	test "name max length" do
		t = Issue.first
		t.Name = "a"*101
		t.valid?
		py_assert(["Max name length is 100 characters."], t.errors[:Name])
	end

	test "needs description" do
		t = Issue.first
		t.Description = nil
		t.valid?
		py_assert(["Please provide an issue description."], t.errors[:Description])
	end

	test "open nil" do
		t = Issue.first
		t.Open = nil
		t.valid?
		py_assert(["Issue may only be open or closed."], t.errors[:Open])
	end

	#TESTS FOR ADVISOR BNUM
	test "advisor bnum matches regex1" do
		t = Issue.first
		t.tep_advisors_AdvisorBnum = "00123456"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:tep_advisors_AdvisorBnum])
	end

	test "advisor bnum matches regex2" do
		t = Issue.first
		t.tep_advisors_AdvisorBnum = "B001234567"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:tep_advisors_AdvisorBnum])
	end

	test "advisor bnum matches regex3" do
		t = Issue.first
		t.tep_advisors_AdvisorBnum = "123456"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:tep_advisors_AdvisorBnum])
	end

	test "advisor bnum matches regex4" do
		t = Issue.first
		t.tep_advisors_AdvisorBnum = "B0012345"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:tep_advisors_AdvisorBnum])
	end

	test "advisor bnum matches regex5" do
		t = Issue.first
		t.tep_advisors_AdvisorBnum = "completly off!"
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:tep_advisors_AdvisorBnum])
	end

	test "advisor blank bnum ok" do
		t = Issue.first
		t.tep_advisors_AdvisorBnum = nil
		t.valid?
		py_assert([], t.errors[:tep_advisors_AdvisorBnum])		
	end

	test "sorted scope" do
		issues = Issue.sorted
		4.times do |i|
			if i < 2
				py_assert(issues[i].Open, true)		#first two records should be open
			else
				py_assert(issues[i].Open, false)
			end

			if i % 2 == 0
				py_assert(issues[i].CreateDate, Date.today+1)	#even records created tomorrow
			else
				py_assert(issues[i].CreateDate, Date.today)	#odd records created today
			end

		end
	end

end

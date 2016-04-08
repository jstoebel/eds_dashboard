require 'test_helper'

class IssueUpdateTest < ActiveSupport::TestCase

	test "needs name" do
		t = IssueUpdate.first
		t.UpdateName = nil
		t.valid?
		py_assert(["Please provide an update name."], t.errors[:UpdateName])
	end

	test "name max length" do
		t = IssueUpdate.first
		t.UpdateName = "a"*101
		t.valid?
		py_assert(["Max name length is 100 characters."], t.errors[:UpdateName])
	end

	test "needs description" do
		t = IssueUpdate.first
		t.Description = nil
		t.valid?
		py_assert(["Please provide an update description."], t.errors[:Description])
	end

	test "advisor blank bnum bad" do
		t = IssueUpdate.first
		t.tep_advisors_AdvisorBnum = nil
		t.valid?
		py_assert(["Please enter a valid B#, (including the B00)"], t.errors[:tep_advisors_AdvisorBnum])		
	end

	test "scope sorted" do
		expected = IssueUpdate.all.order(created_at: :desc).to_a
		actual = IssueUpdate.all.sorted.to_a
		py_assert(expected, actual)
	end
end

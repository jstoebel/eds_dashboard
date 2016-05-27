# == Schema Information
#
# Table name: issue_updates
#
#  UpdateID                 :integer          not null, primary key
#  UpdateName               :text             not null
#  Description              :text             not null
#  Issues_IssueID           :integer          not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#

require 'test_helper'

class IssueUpdateTest < ActiveSupport::TestCase

	test "needs name" do
		t = IssueUpdate.first
		t.UpdateName = nil
		t.valid?
		py_assert(["Please provide an update name."], t.errors[:UpdateName])
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
		assert t.errors[:tep_advisors_AdvisorBnum].include?("Could not find an advisor profile for this user.")		
	end

	test "scope sorted" do
		expected = IssueUpdate.all.order(created_at: :desc).to_a
		actual = IssueUpdate.all.sorted.to_a
		assert_equal(expected, actual)
	end
end

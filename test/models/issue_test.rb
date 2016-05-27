# == Schema Information
#
# Table name: issues
#
#  IssueID                  :integer          not null, primary key
#  student_id               :integer          not null
#  Name                     :text             not null
#  Description              :text             not null
#  Open                     :boolean          default(TRUE), not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#

require 'test_helper'

class IssueTest < ActiveSupport::TestCase


	#TESTS FOR STUDENT BNUM

	test "needs name" do
		t = Issue.first
		t.Name = nil
		t.valid?
		assert_equal(["Please provide an issue name."], t.errors[:Name])
	end

	test "needs description" do
		t = Issue.first
		t.Description = nil
		t.valid?
		assert_equal(["Please provide an issue description."], t.errors[:Description])
	end

	test "open nil" do
		t = Issue.first
		t.Open = nil
		t.valid?
		assert_equal(["Issue may only be open or closed."], t.errors[:Open])
	end

	#TESTS FOR ADVISOR BNUM
	test "advisor blank bnum bad" do
		t = Issue.first
		t.tep_advisors_AdvisorBnum = nil
		t.valid?
		assert t.errors[:tep_advisors_AdvisorBnum].include?("Could not find an advisor profile for this user.")
	end

	test "sorted scope" do
		scoped = Issue.sorted
		expected = Issue.all.order(:Open => :desc, :created_at => :desc)

		assert_equal scoped.to_a, expected.to_a

	end

end

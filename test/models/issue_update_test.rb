# == Schema Information
#
# Table name: issue_updates
#
#  UpdateID                 :integer          not null, primary key
#  UpdateName               :text(65535)      not null
#  Description              :text(65535)      not null
#  Issues_IssueID           :integer          not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#  visible                  :boolean          default(TRUE), not null
#  addressed                :boolean
#  status                   :string(255)
#

require 'test_helper'

class IssueUpdateTest < ActiveSupport::TestCase

	test "needs name" do
		t = FactoryGirl.create :issue_update
		t.UpdateName = nil
		t.valid?
		py_assert(["Please provide an update name."], t.errors[:UpdateName])
	end

	test "needs description" do
		t = FactoryGirl.create :issue_update
		t.Description = nil
		t.valid?
		py_assert(["Please provide an update description."], t.errors[:Description])
	end

	test "advisor blank bnum bad" do
		t = FactoryGirl.create :issue_update
		t.tep_advisors_AdvisorBnum = nil
		t.valid?
		assert t.errors[:tep_advisors_AdvisorBnum].include?("Could not find an advisor profile for this user.")
	end

	test "scope sorted" do
		(1..5).each{|i| FactoryGirl.create :issue_update, :created_at => DateTime.now + i}
		expected = IssueUpdate.all.order(created_at: :desc).to_a
		actual = IssueUpdate.all.sorted.to_a
		assert_equal(expected, actual)
	end

	describe "resolves?" do

		[true, false].each do |bool|
			test "returns #{bool.to_s}" do
				@update = FactoryGirl.create :issue_update, {:status => (bool ? :resolved : :concern)}
				assert_equal bool, @update.resolves?
			end
		end

	end

end

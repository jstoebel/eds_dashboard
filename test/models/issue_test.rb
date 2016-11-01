# == Schema Information
#
# Table name: issues
#
#  IssueID                  :integer          not null, primary key
#  student_id               :integer          not null
#  Name                     :text(65535)      not null
#  Description              :text(65535)      not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#  visible                  :boolean          default(TRUE), not null
#  positive                 :boolean
#  disposition_id           :integer
#

require 'test_helper'

class IssueTest < ActiveSupport::TestCase


	#TESTS FOR STUDENT BNUM

	test "needs name" do
		t = FactoryGirl.create :issue
		t.Name = nil
		t.valid?
		assert_equal(["Please provide an issue name."], t.errors[:Name])
	end

	test "needs description" do
		t = FactoryGirl.create :issue
		t.Description = nil
		t.valid?
		assert_equal(["Please provide an issue description."], t.errors[:Description])
	end

	#TESTS FOR ADVISOR BNUM
	test "advisor blank bnum bad" do
		t = FactoryGirl.create :issue
		t.tep_advisors_AdvisorBnum = nil
		t.valid?
		assert t.errors[:tep_advisors_AdvisorBnum].include?("Could not find an advisor profile for this user.")
	end

	test "sorted scope" do
		(0..10).each{|i| FactoryGirl.create :issue, :created_at => DateTime.now + i}
		scoped = Issue.sorted
		expected = Issue.all.order(:created_at => :desc)

		assert_equal scoped.to_a, expected.to_a

	end

	test "hides updates from an issue" do
		issue = FactoryGirl.create(:issue)
		# making an update belonging to this issue that is shared with an advisor
    	# update = FactoryGirl.create(:issue_update, {:Issues_IssueID => issue.id, :tep_advisors_AdvisorBnum => issue.tep_advisors_AdvisorBnum })
    	update  = IssueUpdate.create({:UpdateName => "Name",
    		:Description => "Desc.",
    		:Issues_IssueID => issue.id,
    		:tep_advisors_AdvisorBnum => issue.tep_advisors_AdvisorBnum })
    	issue.visible = false
    	issue.save
    	issue.issue_updates.each{|u| assert_not u.visible}
	end

	describe "resolved and open" do

		describe "not resolved" do

			before do
				@issue = FactoryGirl.create(:issue, first_status: :concern)
			end

			let(:not_resolved) {assert_not @issue.resolved?}
			let(:is_open) {assert @issue.open?}

			test "one bad update" do
				not_resolved
				is_open
			end

			test "bad, good, bad" do
				[:resolved, :concern].each_with_index do |status, i|
					FactoryGirl.create :issue_update, {
						:status => status,
						:Issues_IssueID => @issue.id,
						:created_at => DateTime.now + i  #ensure time stamps order correctly.
					}
					not_resolved
					is_open
				end # loop

			end # test

			test "progressing is not resolved" do
				FactoryGirl.create :issue_update, {
					status: :progressing,
					:Issues_IssueID => @issue.id
				}

				not_resolved
				is_open
			end # test

		end # returns false

		describe "resolved" do

			before do
				@issue = FactoryGirl.create(:issue, first_status: :resolved)
			end

			test "one good update" do
				assert @issue.resolved?
				assert_not @issue.open?
			end

			test "good, bad, good" do
				[:concern, :resolved].each_with_index do |status, i|
					FactoryGirl.create :issue_update, {
						:status => status,
						:Issues_IssueID => @issue.id,
						:created_at => (DateTime.now + i) #ensure time stamps order correctly.
					}
					assert @issue.resolved?
					assert_not @issue.open?
				end
			end
		end #describe


	end # outer describe

	test "current_status" do
		issue = FactoryGirl.create :issue
		second_update = FactoryGirl.create :issue_update,
			{ :Issues_IssueID => issue.id,
				:created_at => issue.issue_updates.last.created_at + 10}
		assert_equal second_update, issue.current_status
	end

end

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
	test "blank bnum bad" do
		t = Issue.first
		t.student_id = nil
		t.valid?
		assert_equal(["Please enter a valid B#, (including the B00)"], t.errors[:student_id])		
	end

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
		assert_equal(["Please enter a valid B#, (including the B00)"], t.errors[:tep_advisors_AdvisorBnum])		
	end

	test "sorted scope" do
		# issues = Issue.sorted
		# 4.times do |i|
		# 	if i < 2
		# 		assert_equal(issues[i].Open, true)		#first two records should be open
		# 	else
		# 		assert_equal(issues[i].Open, false)
		# 	end

		# 	if i % 2 == 0
		# 		assert_equal(issues[i].CreateDate, Date.today+1)	#even records created tomorrow
		# 	else
		# 		assert_equal(issues[i].CreateDate, Date.today)	#odd records created today
		# 	end

		# end

		scoped = Issue.sorted
		expected = Issue.all.order(:Open => :desc, :created_at => :desc)

		assert_equal scoped.to_a, expected.to_a

	end

end

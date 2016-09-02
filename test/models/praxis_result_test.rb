# == Schema Information
#
# Table name: praxis_results
#
#  id             :integer          not null, primary key
#  student_id     :integer          not null
#  praxis_test_id :integer
#  test_date      :datetime
#  reg_date       :datetime
#  paid_by        :string(255)
#  test_score     :integer
#  best_score     :integer
#

require 'test_helper'

class PraxisResultTest < ActiveSupport::TestCase


	test "blank bnum" do
		t = PraxisResult.first
		t.student_id = nil
		t.valid?
		assert_equal(["Please select a student."], t.errors[:student_id])
	end

	test "blank test code" do
		t = PraxisResult.first
		t.praxis_test_id = nil
		t.valid?
		assert_equal(["Test must be selected."], t.errors[:praxis_test_id])
	end

	test "blank test date" do
		t = PraxisResult.first
		t.test_date = nil
		t.valid?
		assert_equal(["Test date must be selected."], t.errors[:test_date])
	end

	test "blank reg date" do
		t = PraxisResult.first
		t.reg_date = nil
		t.valid?
		assert_equal(["Registration date must be selected."], t.errors[:reg_date])
	end


	test "blank paid by" do
		t = PraxisResult.first
		t.paid_by = nil
		t.valid?
		assert_equal(["Payment source must be given."], t.errors[:paid_by])
	end

	test "bad paid by" do
		t = PraxisResult.first
		t.paid_by = "it was free!"
		t.valid?
		assert_equal(["Invalid payment source."], t.errors[:paid_by])
	end

	test "allows edit no score" do
		test = PraxisResult.where(test_score: nil).first
		test.reg_date = Date.today
		test.valid?
		assert test.valid?, test.errors.full_messages
	end

	test "allows edit new record" do

		old_test = PraxisResult.first
		old_attr = old_test.attributes
		[:id, :test_score].map {|a| old_attr.delete(a)}	#remove these attrs

		test = PraxisResult.new old_attr
		test.test_date += 1	#change this attr
		assert test.valid?
	end

	test "prevents from edit" do
		test = PraxisResult.where(test_score: nil).first
		test.test_score = 123
		assert test.valid?
		test.save
		test.reg_date = Date.today
		test.valid?
		assert_equal ["Test has scores and may not be altered."], test.errors[:base]
	end

	test "prevents from destroy" do
		test = PraxisResult.where(test_score: nil).first
		test.test_score = 123
		assert test.valid?
		test.save
		test.destroy
		assert_equal ["Test has scores and may not be altered."], test.errors[:base]
	end

	test "passing returns true" do
		pr = FactoryGirl.create :praxis_result
		pr.test_score = (pr.praxis_test.CutScore)
		pr.save!({:validate => false})

		assert pr.passing?

	end

	test "passing returns false" do
		pr = FactoryGirl.create :praxis_result
		pr.test_score = (pr.praxis_test.CutScore) - 1
		pr.save!({:validate => false})

		assert_not pr.passing?

	end

end

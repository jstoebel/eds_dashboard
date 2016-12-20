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

	describe "basic validations" do
		before do
			@test = PraxisResult.new
			@test.valid?
		end

		test "student_id" do
			assert_equal ["Please select a student."], @test.errors[:student_id]
		end

		test "blank test code" do
			assert_equal ["Test must be selected."], @test.errors[:praxis_test_id]
		end

		test "blank test date" do
			assert_equal(["Test date must be selected."], @test.errors[:test_date])
		end

		test "blank reg date" do
			assert_equal(["Registration date must be selected."], @test.errors[:reg_date])
		end
		test "blank paid by" do
			assert_equal(["Payment source must be given."], @test.errors[:paid_by])
		end

		test "bad paid by" do
			assert_equal(["Invalid payment source."], @test.errors[:paid_by])
		end
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

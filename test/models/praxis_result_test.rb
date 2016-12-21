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
			@test.paid_by = "bad source"
			@test.valid?
			assert_equal(["Invalid payment source."], @test.errors[:paid_by])
		end
	end


	test "allows edit no score" do
		result = FactoryGirl.create :praxis_result, {:test_score => nil}
		result.reg_date = Date.today
		result.valid?
		assert result.valid?, result.errors.full_messages
	end

	test "allows edit new record" do

		result = FactoryGirl.build :praxis_result, :test_score => 150
		result.test_date += 1
		assert result.valid?
	end

	test "prevents from edit" do
		result = FactoryGirl.create :praxis_result, :test_score => 150
		result.reg_date = Date.today
		result.valid?
		assert_equal ["Test has scores and may not be altered."], result.errors[:base]
	end

	test "prevents from destroy" do
		result = FactoryGirl.create :praxis_result, :test_score => 150
		result.destroy
		assert_equal ["Test has scores and may not be altered."], result.errors[:base]
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

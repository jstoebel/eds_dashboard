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

end

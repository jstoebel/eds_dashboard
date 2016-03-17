require 'test_helper'

class PraxisResultTest < ActiveSupport::TestCase

	
	test "blank bnum" do
		t = PraxisResult.first
		t.student_id = nil
		t.valid?
		py_assert(["Please select a student."], t.errors[:Bnum])		
	end

	test "blank test code" do
		t = PraxisResult.first
		t.test_code = nil
		t.valid?
		py_assert(["Test must be selected."], t.errors[:TestCode])		
	end

	test "blank test date" do
		t = PraxisResult.first
		t.test_date = nil
		t.valid?
		py_assert(["Test date must be selected."], t.errors[:TestDate])		
	end

	test "blank reg date" do
		t = PraxisResult.first
		t.paid_by = nil
		t.valid?
		py_assert(["Registration date must be selected."], t.errors[:RegDate])		
	end


	test "blank paid by" do
		t = PraxisResult.first
		t.paid_by = nil
		t.valid?
		py_assert(["Payment source must be given."], t.errors[:PaidBy])		
	end

	test "bad paid by" do
		t = PraxisResult.first
		t.paid_by = "it was free!"
		t.valid?
		py_assert(["Invalid payment source."], t.errors[:PaidBy])		
	end

end

require 'test_helper'

class AdmStTest < ActiveSupport::TestCase

	test "valid letter" do
		app = AdmSt.first
		app.letter_file_name = nil
		app.skip_val_letter = false
		app.valid?
		py_assert(app.errors[:base], ["Please attach an admission letter."])
	end

	test "skip letter validation" do
		app = AdmSt.first
		app.letter_file_name = nil
		app.skip_val_letter = true
		app.valid?
		py_assert([], app.errors[:base])
	end

	test "admitted too early" do
		app = AdmSt.first
		app.STAdmitDate = Date.strptime("8/31/2015", "%m/%d/%Y")
		app.valid?
		py_assert(["Admission date must be after term begins."], app.errors[:STAdmitDate])
	end

	test "admitted too late" do
		app = AdmSt.first
		app.STAdmitDate = Date.strptime("01/01/2016", "%m/%d/%Y")
		app.valid?
		py_assert(["Admission date may not be before next term begins."], app.errors[:STAdmitDate])
	end

	test "admission date missing" do
		app = AdmSt.first
		app.STAdmitDate = nil
		app.valid?
		py_assert(["Admission date must be given."], app.errors[:STAdmitDate])
	end

	test "no date error if not admitted" do
		app = AdmSt.first
		app.STAdmitted = false
		app.valid?
		py_assert([], app.errors[:STAdmitted])
	end




end

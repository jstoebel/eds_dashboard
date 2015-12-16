require 'test_helper'

class AdmStTest < ActiveSupport::TestCase

	test "check fks" do
		app = AdmSt.new
		app.valid?
		py_assert(app.errors.full_messages, ["Student bnum No student selected.", "Bannerterm bannerterm No term could be determined."]
)
	end

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
		app.STAdmitDate = Date.strptime("8/25/2015", "%m/%d/%Y")
		app.valid?
		py_assert(["Admission date must be after term begins."], app.errors[:STAdmitDate])
	end

	test "admitted too late" do
		app = AdmSt.first
		app.STAdmitDate = Date.strptime("01/12/2016", "%m/%d/%Y")
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

	test "has open or accepted application this term" do
		app1 = AdmSt.first
		app2 = AdmSt.new(app1.attributes)
		app2.valid?
		py_assert(["Student has already been admitted or has an open applicaiton in this term."], app2.errors[:base])
	end

	test "scope by term" do
		expected_apps = AdmSt.by_term(201511)
		actual_apps = AdmSt.all

		py_assert(expected_apps.slice(0, expected_apps.size), actual_apps.slice(0, actual_apps.size))

	end

end

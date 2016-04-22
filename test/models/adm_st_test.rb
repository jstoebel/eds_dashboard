require 'test_helper'
require 'paperclip'
include ActionDispatch::TestProcess
class AdmStTest < ActiveSupport::TestCase

	test "check fks" do
		app = AdmSt.new
		app.valid?
		assert_equal(app.errors.full_messages, ["Student No student selected.", "Bannerterm bannerterm No term could be determined."]
)
	end

	test "need valid letter" do
		app = AdmSt.first
		app.skip_val_letter = false
		app.valid?
		assert_equal(app.errors[:student_file_id], ["Please attach an admission letter."])
	end

	test "skip letter validation" do
		app = AdmSt.first
		app.student_file_id = nil
		app.skip_val_letter = true
		app.valid?
		assert_equal([], app.errors[:base])
	end

	test "admitted too early" do
		app = AdmSt.first
		letter = attach_letter(app)
		prior_term = app.banner_term.prev_term
		app.STAdmitDate = prior_term.EndDate
		app.valid?
		assert_equal(["Admission date must be after term begins."], app.errors[:STAdmitDate])
	end

	test "admitted too late" do
		app = AdmSt.first
		letter = attach_letter(app)
		next_term = app.banner_term.next_term

		app.STAdmitDate = next_term.StartDate
		app.valid?
		assert_equal(["Admission date may not be before next term begins."], app.errors[:STAdmitDate])
	end

	test "admission date missing" do
		app = AdmSt.first
		letter = attach_letter(app)
		app.STAdmitDate = nil
		app.valid?
		assert_equal(["Admission date must be given."], app.errors[:STAdmitDate])
	end

	test "no date error if not admitted" do
		app = AdmSt.first
		app.STAdmitted = false
		app.valid?
		assert_equal([], app.errors[:STAdmitted])
	end

	test "has open or accepted application this term" do
		app1 = AdmSt.first
		letter = attach_letter(app1)
		app2 = AdmSt.new(app1.attributes)
		app2.valid?
		assert_equal(["Student has already been admitted or has an open applicaiton in this term."], app2.errors[:base])
	end

	test "scope by term" do
		expected_apps = AdmSt.by_term(BannerTerm.current_term )
		actual_apps = AdmSt.all

		assert_equal(expected_apps.slice(0, expected_apps.size), actual_apps.slice(0, actual_apps.size))

	end

end

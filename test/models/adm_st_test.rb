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
		py_assert(app.errors[:base], [])
	end

end

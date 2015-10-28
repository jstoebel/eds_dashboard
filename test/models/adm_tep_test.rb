require 'test_helper'

class AdmTepTest < ActiveSupport::TestCase
	
	self.set_fixture_class adm_tep: AdmTep,
							banner_terms: BannerTerm

	test "data are right" do
		app = AdmTep.first
		stu = Student.first
		assert app.Student_Bnum == stu.id
 	end

end

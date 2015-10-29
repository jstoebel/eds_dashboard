require 'test_helper'

class AdmTepTest < ActiveSupport::TestCase
	
	# test "data are right" do
	# 	app = AdmTep.first
	# 	self.my_assert(app.Student_Bnum, app.student.Bnum.to_s)
 # 	end

   test "needs a program" do
   	#test validation: needing a program.
   	 stu = Student.first
     app = AdmTep.new({Student_Bnum: stu.Bnum})
     app.valid?
     
   end


end

class PraxisResultMailer < ApplicationMailer

  def email_student(stu, tests)
     # stu: student record
     # tests: array of all tests taken in score report
     # student is emailed concerns their options to retake the exam.
     # advisors are cc'd
     # admins are bcc'd

     @stu = stu
     @passing_tests = []
     @failing_tests = []
     tests.each do |exam|
       if exam.passing?
         @passing_tests << exam
       else
         @failing_tests << exam
       end
     end

     mail(:to => @stu.Email,
       :cc => @stu.tep_advisors.pluck(:email),
       :bcc => User.admin_emails,
       :subject => "Praxis Results"
     )
  end

end

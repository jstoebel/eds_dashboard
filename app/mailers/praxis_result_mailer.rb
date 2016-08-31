class PraxisResultMailer < ApplicationMailer

  def email_student(stu, failing_tests)
     #stu: student record
     # failing_tets, AR::relation of all failing tests in current report
     # student is emailed concerns their options to retake the exam.

     @stu = stu
     mail(:to => @stu.Email,
     :cc => SECRET["APP_ADMIN_EMAIL"],
     :subject => "Praxis Results"
     )

  end

  def email_advisor


  end

  def email_admins

  end

end

class PraxisResultMailer < ApplicationMailer

  def email_student(stu, failing_tests)
     #stu: student record
     # failing_tets, AR::relation of all failing tests for stu in current report
     # student is emailed concerns their options to retake the exam.

     @stu = stu
     @failing_tests = failing_tests
     mail(:to => @stu.Email,
     :bcc => User.admin_emails,
     :subject => "Praxis Results"
     )

  end

  def email_advisors(adv, stu, tests)
    # emails an advisor reguarding all tests student took in a given report
    # stu: student record
    # tests: AR::relation of all tests for stu in current report
    @stu = stu
    @tests = tests
    @adv = adv
    mail(:to => @adv.email,
      :bcc => SECRET["APP_ADMIN_EMAIL"],
      :subject => "Praxis Results for #{@stu.name_readable}"
    )
  end

end

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

  def email_summary(reports, report_date)
    # email summary when a new report is done processing
    # include names of each report completed
    # star each name that wasn't matched with a ssn
    # report_date(str) the date of the praxis report
    # data: array of report_objects

    @reports = reports
    @report_date = report_date

    mail(:to => SECRET["APP_ADMIN_EMAIL"],
      :subject => "Praxis Result Summary"
    )
  end

end

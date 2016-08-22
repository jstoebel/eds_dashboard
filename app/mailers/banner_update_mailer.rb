class BannerUpdateMailer < ApplicationMailer

  def possible_drop(stu, adv)
    # stu (Student object) that this email is about
    # adv (TepAdvisor object): the recipient advisor
    # notifies all TEP_advisors related to stu about possible drop
    @stu = stu
    @adv = adv
    mail(:to => adv.get_email,
      :cc => [SECRET["APP_ADMIN_EMAIL"], "rosenbarkerl@berea.edu"],
      :subject => "Possible TEP status change for #{@stu.name_readable}")
  end

  def add_drop_advisor(stu, adv, status)
    # stu (Student object) that this email is about
    # adv (TepAdvisor object): the recipient advisor
    # notifies an advisor that they have been added to /removed from a student

    @stu = stu
    @adv = adv
    @status = status
    mail(:to => adv.get_email,
      :cc => [SECRET["APP_ADMIN_EMAIL"], "rosenbarkerl@berea.edu"],
      :subject => "Advisee status change for #{@stu.name_readable}")
  end

  def update_done(timestamp, error_count)
    # timestamp (datetime): time of task execution
    # error_count(int) number of caught errors.

    @timestamp = timestamp
    @error_count = error_count
    mail(:to => SECRET["APP_ADMIN_EMAIL"],
      :subject => "banner_update task finished successfully"
    )
  end

end

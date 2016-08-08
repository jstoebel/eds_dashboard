class BannerUpdate < ApplicationMailer

  def notify_possible_drop(stu, adv)
    # stu (Student object) that this email is about
    # adv (TepAdvisor object): the recipient advisor
    # notifies all TEP_advisors related to stu about possible drop
    @stu = stu
    @adv = adv
    mail(:to => adv.get_email,
      :cc => ["stoebelj@berea.edu", "rosenbarkerl@berea.edu"],
      :subject => "Possible TEP status change for #{@stu.name_readable}")
  end
end

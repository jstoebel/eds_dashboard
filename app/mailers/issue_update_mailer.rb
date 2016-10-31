class IssueUpdateMailer < ApplicationMailer

  def alert_new(stu, adv)
    # stu: student AR object this email is about
    # adv: tep_advisor profile
    @stu = stu
    @adv = adv
    mail(:to => adv.get_email,
      :cc => [SECRET["APP_ADMIN_EMAIL"]],
      :subject => "Issue for #{@stu.name_readable}")
  end

end

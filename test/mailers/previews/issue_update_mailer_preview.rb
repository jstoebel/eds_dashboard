# Preview all emails at http://localhost:3000/rails/mailers/issue_update_mailer
class IssueUpdateMailerPreview < ActionMailer::Preview

  def alert_new
    stu = FactoryGirl.build_stubbed :student
    adv = FactoryGirl.build_stubbed :tep_advisor
    return IssueUpdateMailer.alert_new(stu, adv)
  end

end

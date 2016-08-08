class ApplicationMailer < ActionMailer::Base
  default from: "EDS_Dashboard@berea.edu", reply_to: "stoebelj@berea.edu"
  layout 'mailer'
end

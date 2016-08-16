class ApplicationMailer < ActionMailer::Base
  default from: SECRET["APP_EMAIL_ADDRESS"], reply_to: SECRET["APP_ADMIN_EMAIL"]
  layout 'mailer'
end

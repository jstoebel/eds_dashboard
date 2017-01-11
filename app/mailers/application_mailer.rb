class ApplicationMailer < ActionMailer::Base
  default from: SECRET["APP_EMAIL_ADDRESS"], reply_to: SECRET["APP_ADMIN_EMAIL"]
  layout 'mailer'

  def gem_security_alert(unpatched_gems, insecure_source)
    # unpatched_gems (array) list of all gems that need to be patched
    # insecure_source (array) list of all gems with an insecure source (http)

    @unpatched_gems = unpatched_gems
    @insecure_source = insecure_source
    mail(:to => SECRET["APP_ADMIN_EMAIL"],
      :subject => "Security Alert for EDS Dashboard"
    )
  end
end

require 'test_helper'

class AdminMailerTest < ActionMailer::TestCase

  test "gem_security_alert" do
    unpatched_gems = (1..3).map {|g| "gem#{g}"}
    insecure_source = (1..3).map {|i| "url#{i}"}
    email = AdminMailer.gem_security_alert(unpatched_gems, insecure_source)
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal email.to, [SECRET["APP_ADMIN_EMAIL"]]
    assert_equal email.subject, "Security Alert for EDS Dashboard"
  end

end

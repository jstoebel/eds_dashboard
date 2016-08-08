require 'test_helper'

class BannerUpdateMailerTest < ActionMailer::TestCase

  describe "notify possible drop" do

    before do

      assignment = FactoryGirl.create :advisor_assignment
      @stu = assignment.student
      @adv = assignment.tep_advisor
      @email = BannerUpdateMailer.notify_possible_drop(assignment.student, assignment.tep_advisor)

      assert_emails 1 do
        @email.deliver_now
      end
    end

    it "sends to an advisor" do
      assert_equal @email.to, [@adv.get_email]
      assert_equal @email.cc, ["stoebelj@berea.edu", "rosenbarkerl@berea.edu"]
      assert_equal @email.subject, "Possible TEP status change for #{@stu.name_readable}"

    end

  end

end

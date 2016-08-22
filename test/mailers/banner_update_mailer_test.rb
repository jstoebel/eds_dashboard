require 'test_helper'

class BannerUpdateMailerTest < ActionMailer::TestCase

  describe "notify possible drop" do

    before do

      assignment = FactoryGirl.create :advisor_assignment
      @stu = assignment.student
      @adv = assignment.tep_advisor
      @email = BannerUpdateMailer.possible_drop(assignment.student, assignment.tep_advisor)

      assert_emails 1 do
        @email.deliver_now
      end
    end

    it "sends to an advisor" do
      assert_equal @email.to, [@adv.get_email]
      assert_equal @email.cc, [SECRET["APP_ADMIN_EMAIL"], "rosenbarkerl@berea.edu"]
      assert_equal @email.subject, "Possible TEP status change for #{@stu.name_readable}"

    end

  end

  describe "notify add_drop advisor" do

    before do
      assignment = FactoryGirl.create :advisor_assignment
      @stu = assignment.student
      @adv = assignment.tep_advisor
    end

    it "notifies advisee add" do
      @email = BannerUpdateMailer.add_drop_advisor(@stu, @adv)

      assert_emails 1 do
        @email.deliver_now
      end

      assert_equal @email.to, [@adv.get_email]
      assert_equal @email.cc, [SECRET["APP_ADMIN_EMAIL"], "rosenbarkerl@berea.edu"]
      assert_equal @email.subject, "Advisee status change for #{@stu.name_readable}"
      assert_match /added/, @email.body.to_s
    end

    it "notifies advisee remove" do
      AdvisorAssignment.delete_all
      @email = BannerUpdateMailer.add_drop_advisor(@stu, @adv)

      assert_emails 1 do
        @email.deliver_now
      end

      assert_equal @email.to, [@adv.get_email]
      assert_equal @email.cc, [SECRET["APP_ADMIN_EMAIL"], "rosenbarkerl@berea.edu"]
      assert_equal @email.subject, "Advisee status change for #{@stu.name_readable}"
      assert_match /removed/, @email.body.to_s
    end

  end

end

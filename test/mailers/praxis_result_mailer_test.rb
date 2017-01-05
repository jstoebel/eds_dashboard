require 'test_helper'

class PraxisResultMailerTest < ActionMailer::TestCase

  before do
    @stu = FactoryGirl.create :student, :Email => "student@test.edu"
    @tests = []
    [1, -1].each do |modifier|
      pr = FactoryGirl.build_stubbed :praxis_result
      pr.test_score = (pr.cut_score) + modifier
      @tests.push pr
    end

    @adv = FactoryGirl.create :tep_advisor

    AdvisorAssignment.create({:student_id => @stu.id,
        :tep_advisor_id => @adv.id
      })

  end

  describe "email student" do

    before do
      @email = PraxisResultMailer.email_student @stu, @tests

      assert_emails 1 do
        @email.deliver_now
      end

    end

    test "emails student" do
      assert_equal [@stu.Email], @email.to
    end

    test "ccs advisors" do
      assert_equal @stu.tep_advisors.pluck(:email), @email.cc
    end

    test "bccs admins" do
      assert_equal User.admin_emails, User.where({:Roles_idRoles => 1}).pluck(:Email)
    end

    test "subject: Praxis Results" do
      assert_equal "Praxis Results", @email.subject
    end

  end

  # describe "email advisor" do
  #
  #   before do
  #     @email = PraxisResultMailer.email_advisor(@adv, @stu, @failing_tests)
  #
  #     assert_emails 1 do
  #       @email.deliver_now
  #     end
  #
  #   end
  #
  #   test "emails advisor" do
  #     assert_equal [@adv.email], @email.to
  #   end
  #
  #   test "bccs app admin" do
  #     assert_equal [SECRET["APP_ADMIN_EMAIL"]], @email.bcc
  #   end
  #
  #   test "subject" do
  #     assert_equal "Praxis Results for #{@stu.name_readable}", @email.subject
  #   end
  #
  # end

end

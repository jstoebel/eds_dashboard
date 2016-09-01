require 'test_helper'

class PraxisResultMailerTest < ActionMailer::TestCase

  before do
    @failing_tests = FactoryGirl.create_list :praxis_result, 2 # its ok that its not actually failing
    @stu = failing_test.student
    @adv = FactoryGirl.create :tep_advisor

    AdvisorAssignment.create({:student_id => @stu.id,
        :tep_advisor_id => @adv.id
      })

  end

  describe "email student" do

    before do
      @email = PraxisResultMailer.email_student @stu, @failing_tests

      assert_emails 1 do
        @email.deliver_now
      end

    end

    test "emails student" do
      assert_equal @stu.Email, @email.to
    end

    test "bccs admins" do
      assert_equal User.admin_emails, User.where({:Roles_idRoles => 1}).pluck :Email
    end

    test "subject: Praxis Results" do
      assert_equal "Praxis Results", @email.subject
    end

  end

  describe "email advisor" do

    before do
      @email = PraxisResultMailer.email_advisor(@adv, @stu, @failing_tests)

      assert_emails 1 do
        @email.deliver_now
      end

    end

    test "emails advisor" do
      assert_equal @adv.email, @email.to
    end

    test "bccs app admin" do

    end

    test "subject" do

    end

  end

end

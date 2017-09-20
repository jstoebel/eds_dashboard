# == Schema Information
#
# Table name: issue_updates
#
#  UpdateID                 :integer          not null, primary key
#  UpdateName               :text(65535)      not null
#  Description              :text(65535)      not null
#  Issues_IssueID           :integer          not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#  visible                  :boolean          default(TRUE), not null
#  addressed                :boolean
#  status                   :string(255)
#

require 'test_helper'

class IssueUpdateTest < ActiveSupport::TestCase

  test "needs name" do
    t = FactoryGirl.create :issue_update
    t.UpdateName = nil
    t.valid?
    assert_equal(["Please provide an update name."], t.errors[:UpdateName])
  end

  test "needs description" do
    t = FactoryGirl.create :issue_update
    t.Description = nil
    t.valid?
    assert_equal(["Please provide an update description."], t.errors[:Description])
  end

  test "advisor blank bnum bad" do
    t = FactoryGirl.create :issue_update
    t.tep_advisors_AdvisorBnum = nil
    t.valid?
    assert t.errors[:tep_advisors_AdvisorBnum].include?("Could not find an advisor profile for this user.")
  end

  test "scope sorted" do
    (1..5).each{|i| FactoryGirl.create :issue_update, :created_at => DateTime.now + i}
    expected = IssueUpdate.all.order(created_at: :desc).to_a
    actual = IssueUpdate.all.sorted.to_a
    assert_equal(expected, actual)
  end

    test "needs a status" do
        t = FactoryGirl.create :issue_update
    t.status = nil
    t.valid?
    assert t.errors[:status].include?("Please select a status for this update")
    end

    test "invalid status" do
        t = FactoryGirl.create :issue_update
    t.status = "bad status"
    t.valid?
    assert t.errors[:status].include?("Invalid status name")
    end

    describe "addressed must be true or false" do
        before do
            @update = FactoryGirl.build :issue_update
        end
        [true, false].each do |a|
            test "addressed = #{a}" do
                @update.addressed = a
                assert @update.valid?
            end
        end

        test "addressed = nil" do
            @update.addressed = nil
            assert_not @update.valid?
            assert @update.errors[:addressed].include? "addressed may not be nil"
        end

    end

  describe "resolves?" do

    [true, false].each do |bool|
      test "returns #{bool.to_s}" do
        @update = FactoryGirl.create :issue_update, {:status => (bool ? :resolved : :concern)}
        assert_equal bool, @update.resolves?
      end
    end
  end

  describe "creation triggers an email" do

    test "emails advisor" do
      assignment = FactoryGirl.create :advisor_assignment
      stu = assignment.student
      adv = assignment.tep_advisor
      issue = FactoryGirl.create :issue, {:student_id => stu.id}

      all_emails = ActionMailer::Base.deliveries
      all_recipients = all_emails.map{|email| email.to}.flatten
      all_subjects =  all_emails.map{|email| email.subject}

      # subjects match
      all_subjects.each{|subject| assert_equal("Issue for #{stu.name_readable}", subject)}
      # recipients match
      assert all_recipients.include? adv.get_email
      # its from APP_EMAIL_ADDRESS
      assert all_emails.each{|email| assert_equal([SECRET["APP_EMAIL_ADDRESS"]], email.from)}

    end

    test "emails tep_instructor" do
      # assert false, "this test appears to not be working. I think that the model isn't pull tep_instructors properly."

      user = FactoryGirl.create :advisor
      adv = FactoryGirl.create :tep_advisor, :user_id => user.id
      stu = FactoryGirl.create :student
      term = BannerTerm.current_term({:exact => false, :plan_b => :back})
      course = FactoryGirl.create :transcript,
      {:instructors => "InstFirst InstLast {#{adv.AdvisorBnum}}",
      :student_id => stu.id,
      :term_taken => term.id
    }
      issue = FactoryGirl.create :issue, {:student_id => stu.id}


      all_emails = ActionMailer::Base.deliveries
      all_recipients = all_emails.map{|email| email.to}.flatten
      all_subjects =  all_emails.map{|email| email.subject}

      all_subjects.each{|subject| assert_equal("Issue for #{stu.name_readable}", subject)}
      assert all_recipients.include? adv.get_email
      assert all_emails.each{|email| assert_equal([SECRET["APP_EMAIL_ADDRESS"]], email.from)}
    end

    test "emails admin" do
      admin = FactoryGirl.create :admin
      adv = FactoryGirl.create :tep_advisor, :user_id => admin.id
      issue = FactoryGirl.create :issue
      stu = issue.student

      all_emails = ActionMailer::Base.deliveries
      all_recipients = all_emails.map{|email| email.to}.flatten
      all_subjects =  all_emails.map{|email| email.subject}

      # subjects match
      all_subjects.each{|subject| assert_equal("Issue for #{stu.name_readable}", subject)}
      # recipients match
      assert all_recipients.include? adv.get_email
      # its from APP_EMAIL_ADDRESS
      assert all_emails.each{|email| assert_equal([SECRET["APP_EMAIL_ADDRESS"]], email.from)}

    end

  end
  
  test "status_color" do
    # TODO
    # assert what status color should be
    issue = FactoryGirl.create :issue_update, {:status => "progressing"}
    assert_equal issue.status_color, :warning
    
  
  end

end

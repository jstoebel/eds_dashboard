require 'test_helper'
require 'mocha/mini_test'
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

  describe "email summary" do
    before do
      # [
        # a valid score report
          # student object
          # first name
          # last name
        # and invalid score report
          # first name
          # last name
      # ]
      score_report_str = %q(
      <scorereport
        candidateid="12345678"
        reportdate="10/03/2014"
        Program="Praxis">
        <candidateinfo>
          <name>FEE, JOHN</name>
          <ssn>123-45-6789</ssn>
          <address>101 CHESTNUT ST.</address>
          <city>BEREA</city>
          <state>KY</state>
          <zipcode>40404</zipcode>
          <gender>M</gender>
          <dob>01/01/1994</dob>
          <ethnicity>WHITE</ethnicity>
          <highesteduattained>SOPHOMORE (SECOND YEAR)</highesteduattained>
          <ugmajor>MATHEMATICS EDUCATION</ugmajor>
          <gradmajor>NOT PROVIDED</gradmajor>
          <undergradgpa>2.5 - 2.99</undergradgpa>
          <aiorg>BEREA COLLEGE</aiorg>
        </candidateinfo>
        <currenttest>
          <currenttestinfo
            testname="5712 Core Academic Skills for Educators: Reading"
            test_code="5712"
            test_name="Core Academic Skills for Educators: Reading"
            test_type="Computer"
            testscore="170"
            roe=""
            rvsd=""
            testdate="09/16/2014">
            <currenttestcategoryinfo
              testcategory="I. Key Ideas and Details"
              pointsearned="12"
              pointavailable="17"
              avgperformancerange="10 - 14" />
            <currenttestcategoryinfo
              testcategory="II. Craft; Structure; Language Skills"
              pointsearned="9"
              pointavailable="16"
              avgperformancerange="8 - 13" />
            <currenttestcategoryinfo
              testcategory="III. Integration of Knowledge and Ideas"
              pointsearned="9"
              pointavailable="17"
              avgperformancerange="7 - 12" />
          </currenttestinfo>
        </currenttest>
        <hghsttest>
          <hghsttestinfo
            testname="5712 Core Academic Skills for Educators: Reading"
            test_code="5712"
            test_name="Core Academic Skills for Educators: Reading"
            test_type="Computer"
            testscore="170"
            roe=""
            rvsd=""
            testdate="09/16/2014"
            passingstatusasofreportdate="Passed"
            requiredscoreasofreportdate="156"
            requiredminscore=""
            minscoremetnotmet="" />
        </hghsttest>
      </scorereport>
      )

      @score_report = Nokogiri::XML(score_report_str)

    end

    test "for valid report" do
      # the report is matched to a student
      PraxisScoreReport.any_instance.stubs(:stu_from_ssn).returns(FactoryGirl.create :student)
      @report_handler = PraxisScoreReport.new @score_report.root

      summary_email = PraxisResultMailer.email_summary([@report_handler], "01/01/2016")
      summary_email.deliver_now

      assert_equal summary_email.to, [SECRET["APP_ADMIN_EMAIL"]]
      assert_equal summary_email.subject, "Praxis Result Summary"
      assert summary_email.body.include? "JOHN FEE"
      assert summary_email.body.include? "01/01/2016"
    end

    test "for unmatched report" do
      # the report is matched to a student
      PraxisScoreReport.any_instance.stubs(:stu_from_ssn).returns(nil)
      @report_handler = PraxisScoreReport.new @score_report.root

      summary_email = PraxisResultMailer.email_summary([@report_handler], "01/01/2016")
      summary_email.deliver_now

      assert_equal summary_email.to, [SECRET["APP_ADMIN_EMAIL"]]
      assert_equal summary_email.subject, "Praxis Result Summary"
      assert summary_email.body.include? "JOHN FEE UNMATCHED"
      assert summary_email.body.include? "01/01/2016"
    end

  end

end

require 'test_helper'
require 'mocha/mini_test'
class ProcessStudentServiceTest < ActiveSupport::TestCase

  before do
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
    @results0 = PraxisResult.all.size

  end

  describe "write_tests" do

    before do
      PraxisScoreReport.any_instance.stubs(:stu_from_ssn).returns(FactoryGirl.create :student)
      @report_handler = PraxisScoreReport.new @score_report.root
    end

    it "writes a praxis result" do
      assert_difference 'PraxisResult.count', 1 do
        @report_handler.write_tests
      end

      assert_equal 0, PraxisResultTemp.count
    end


    it "writes a subtest" do
      assert_difference 'PraxisSubtestResult.count', 3 do
        @report_handler.write_tests
      end

      assert_equal 0, PraxisSubTemp.count
    end

  end

  describe "write_tests fail - no student found" do

    before do
      PraxisScoreReport.any_instance.stubs(:stu_from_ssn).returns(nil)
      @report_handler = PraxisScoreReport.new @score_report.root
    end

    it "writes a praxis result temp" do

      assert_difference 'PraxisResultTemp.count', 1 do
        @report_handler.write_tests
      end

    end


    it "writes a subtest result temp" do
      assert_difference 'PraxisSubTemp.count', 3 do
        @report_handler.write_tests
      end

    end

  end

end

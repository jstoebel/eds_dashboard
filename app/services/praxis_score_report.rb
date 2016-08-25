class PraxisScoreReport

  attr_reader :report, :stu

  def initialize(report)
    #  report(scorereport node object) represening  an ETS score report on one student
    #  stu: student object this report belongs to
    @report = report
    ssn = @report.at_xpath('candidateinfo/ssn').text.gsub("-", "")
    stu = stu_from_ssn ssn
    if stu.nil?
      raise NoStudentFound.new("Could not find a student in Banner with this ssn.")
    else
      @stu = stu
    end
  end


  def write
    # write praxis scores to database

    best_scores = get_best_scores
    tests = @report.xpath("currenttest").xpath("currenttestinfo")
    tests.each do |test|

      test_code = test[:test_code].to_i

      result_attrs = {
        :student_id => @stu.id,
        :praxis_test_id => test_code,
        :test_date => DateTime.strptime(test[:testdate], "%m/%d/%Y"),
        :test_score => test[:testscore],
        :best_score => best_scores[test_code]
      }
      puts result_attrs

      # result = PraxisResult.new(from_ets: true)
      # result.assign_attributes result_attrs
      # result.save!
    end

  end



  private
  # UNCOMMENT ME FOR PRODUCTION!
  # def stu_from_ssn(ssn)
  #   # ssn(string): a social security number (just digits)
  #   # returns the related student object or nil if no student found
  #
  #   # NOTE: a failure to find a student could be because the student misreported
  #   # their SSN to ETS.
  #
  #
  #   DBI.connect("DBI:OCI8:bannerdbrh.berea.edu:1521/rhprod",
  #     SECRET["BANNER_UN"],
  #     SECRET["BANNER_PW"]) do |dbh|
  #       sql = "SELECT * FROM saturn.szvedsd SZVEDSD_SSN = ?"
  #       row = dbh.select_one(sql, ssn)
  #       return Student.find_by :Bnum => row["SZVEDSD_ID"]
  #
  #   end
  #
  # end

  def stu_from_ssn(ssn)
    return FactoryGirl.create :student
  end

  def get_best_scores
    # return a hash of all tests attempted and their best score
    best_scores = {}
    best_tests =  @report.xpath("hghsttest").xpath("hghsttestinfo")
    best_tests.each do |test|
      best_scores.merge!({test[:test_code] => test[:testscore].to_i})
    end
    return best_scores
  end

end

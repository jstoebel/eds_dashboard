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

    puts get_best_scores
    fail

    tests = @report.xpath("currenttest").xpath("currenttestinfo")
    tests.each do |test|
      praxis_test_id = test[:test_code].to_i
      test_date = DateTime.strptime(test[:testdate], "%m/%d/%Y")
      test_score = test[:testscore]

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
    best_tests =  @report.xpath("hghsttest").xpath("hghsttestinfo")

  end

end

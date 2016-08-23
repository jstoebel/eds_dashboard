class PraxisScoreReport

  attr_reader :report, :stu

  def initialize(report)
    #  report(nokogiri xml node object) an ETS score report.
    @report = report
    ssn = @report.at_xpath('scorereport/candidateinfo/ssn').text
    @stu = StuFromSsn.get_result 


  end

end

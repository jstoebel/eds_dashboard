class PraxisScoreReport

  attr_reader :report, :stu



  def initialize(report)
    #  report(scorereport node object) represening  an ETS score report on one student
    #  stu: student object this report belongs to

    @report = report
    @best_scores = get_best_scores
    ssn = @report.at_xpath('candidateinfo/ssn').text.gsub("-", "")
    full_name = @report.at_xpath('candidateinfo/name').text
    @last_name, @first_name = full_name.split(", ")
    stu = stu_from_ssn ssn
    @stu = stu
  end

  def write_tests
    # write praxis scores to database
    # the resulting PraxisResult object is returned


    tests = @report.xpath("currenttest").xpath("currenttestinfo")
    tests.each do |test_node|

      begin
        test_code = test_node[:test_code].to_i

        result_attrs = {
          :student_id => @stu.andand.id,
          :praxis_test_id => test_code,
          :test_date => DateTime.strptime(test_node[:testdate], "%m/%d/%Y"),
          :test_score => test_node[:testscore],
          :best_score => @best_scores[test_code]
        }
        result = _write_test(result_attrs)

      rescue ActiveRecord::RecordInvalid => result_error
        name_info = {:first_name => @first_name,
          :last_name => @last_name }

        temp_result = PraxisResultTemp.create! result_attrs.merge name_info
      end

    end

  end

  private
  def _write_test(result_attrs)
    # writes a single praxis_result to the database
    # result_attrs: attributes to make a praxis_result

    # if successful the created PraxisTest is returned
    # if record can't be created, ActiveRecord::RecordInvalid is thrown

    result = PraxisResult.new(from_ets: true)
    result.assign_attributes result_attrs
    result.save!
    return result
  end

  def _write_subtests(test_node, test_result)
    # handles writing subtests
    # test_node: a currenttestinfo xml node
    # test_result (a PraxisResult object that was successfully saved)

    subtests = test_node.xpath("currenttestcategoryinfo")
    subtests.each do |subtest|
      sub_n, sub_name = sub_test_node[:testcategory].split(". ")
      avg_low, avg_high = sub_test_node[:avgperformancerange].split(" - ")

      core_attrs = {
        :sub_number => RomanNumeral.new(sub_n).to_i,
        :name => sub_name,
        :pts_earned => sub_test_node[:pointsearned],
        :pts_aval => sub_test_node[:pointavailable],
        :avg_high => avg_high,
        :avg_low => avg_low
      }  # attributes for either subtest or temp subtest

      if test_result.kind_of PraxisResult?
        PraxisSubtestResult.create! core_attrs.merge({:praxis_result_id => test_result.id})
      else
        PraxisSubTemp.create! core_attrs.merge({:praxis_result_temp_id => test_result.id})
      end

    end
  end

  def stu_from_ssn(ssn)
    # ssn(string): a social security number (just digits)
    # returns the related student object or nil if no student found

    # NOTE: a failure to find a student could be because the student misreported
    # their SSN to ETS.

    puts "running this! Bad!"
    DBI.connect("DBI:OCI8:bannerdbrh.berea.edu:1521/rhprod",
      SECRET["BANNER_UN"],
      SECRET["BANNER_PW"]) do |dbh|
        sql = "SELECT * FROM saturn.szvedsd SZVEDSD_SSN = ?"
        row = dbh.select_one(sql, ssn)
        return Student.find_by :Bnum => row["SZVEDSD_ID"]

    end

  end

  # def stu_from_ssn(ssn)
  #   return FactoryGirl.create :student
  # end

  def get_best_scores
    # return a hash of all tests attempted and their best score
    best_scores = {}
    best_tests = @report.xpath("hghsttest").xpath("hghsttestinfo")
    best_tests.each do |test|
      best_scores.merge!({test[:test_code] => test[:testscore].to_i})
    end
    return best_scores
  end

end

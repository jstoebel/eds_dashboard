require 'base64'
task :update_praxis, [:send_emails] => :environment do |t, args|

    send_emails = args[:send_emails] == 'true'

    url = 'https://datamanager.ets.org/edmwebservice/edmpraxis.wsdl'

    user_name = SECRET["PRAXIS_UN"]
    pw = SECRET["PRAXIS_PW"]

    client = Savon.client(wsdl: url)

    # THIS WILL BE THE REAL CODE. USING ETS SERVICE TO FETCH DATA
    print "fetching all available dates..."
    get_these_dates = missing_report_dates(client, user_name, pw)
    puts "-> done!"
    get_these_dates.each do |d|
      score_report = fetch_score_report(client, user_name, pw, d)
      root = score_report.root
      reports = root.xpath("scorereport")
      reports.each do |report|  # one scorereport per student
        report_obj = PraxisScoreReport.new report
        report_obj.write_tests
        report_obj.email if send_emails
      end # loop

    end

    PraxisUpdate.create!({:report_date => DateTime.now})
    # # THIS IS OUR THROW AWAY MOCKED CODE, WHEREIN WE ASSUME A VALID REPORT COMES
    # # IN AND TAKE IT FROM THERE.
    # report_file = File.open(Rails.root.join("test", "praxis_report_sample.xml"))
    # score_report = Nokogiri::XML report_file
    # # END THROW AWAY CODE
end

private

def missing_report_dates(client, user_name, pw)
  # client: SOAP client
  # user_name(str) ETS user name
  # pw(string) ETS password

  # return any reporting dates not already in the system (as DateTime)
  response = client.call(:get_reporting_dates, message: {"clientUserId" => user_name, "clientPassword" => pw })
  dates = Base64.decode64 response.body[:get_reporting_dates_response][:get_reporting_dates_result]
  dates_report = Nokogiri::XML dates
  root = dates_report.root
  date_tags = root.xpath("Date/REPORT_DATE")
  report_dates = date_tags.map { |dt| dt.text}  # strings, format mm/dd/YYYY
  existing_reports = (PraxisUpdate.all.pluck :report_date).map{|d| d.strftime("%m/%d/%Y")}

  puts report_dates - existing_reports
  return (report_dates - existing_reports).uniq
end

def fetch_score_report(client, user_name, pw, date)
  # client: SOAP client
  # user_name(str) ETS user name
  # pw(string) ETS password
  # date(DateTime): the date of the report to fetch

  # return score report (string)

  puts "fetching score_report for #{date}"
  response = client.call(:get_score_reports_given_reporting_date, message: {"clientUserId" => user_name,
      "clientPassword" => pw, "reportDate" => date,
      "strSubProgram" => "P"
       })

   report_str = Base64.decode64 response.body[:get_score_reports_given_reporting_date_response][:get_score_reports_given_reporting_date_result]
   return Nokogiri::XML report_str


end

require 'base64'
task :update_praxis => :environment do
    url = 'https://datamanager.ets.org/edmwebservice/edmpraxis.wsdl'

    user_name = SECRET["PRAXIS_UN"]
    pw = SECRET["PRAXIS_PW"]

    client = Savon.client(wsdl: url)
    get_these_dates = missing_report_dates(client, user_name, pw)

    get_these_dates.each do |d|
      fetch_score_report(client, user_name, pw, d)
    end

end

private

def missing_report_dates(client, user_name, pw)
  # return any reporting dates not already in the system
  response = client.call(:get_reporting_dates, message: {"clientUserId" => user_name, "clientPassword" => pw })
  dates = Base64.decode64 response.body[:get_reporting_dates_response][:get_reporting_dates_result]
  dates_report = Nokogiri::XML dates
  root = dates_report.root
  date_tags = root.xpath("Date/REPORT_DATE")
  report_dates = date_tags.map { |dt| DateTime.strptime(dt.text, "%m/%d/%Y") }

  existing_reports = PraxisUpdate.all.pluck :report_date

  return report_dates - existing_reports
end

def fetch_score_report(client, user_name, pw, date)
  response = client.call(:get_score_reports_given_reporting_date, message: {"clientUserId" => user_name,
      "clientPassword" => pw, "report_date" => date.strftime("%m/%d/%Y"),
      "program_code" => "P"
       })



end

require 'base64'
task :update_praxis, [:send_emails] => :environment do |t, args|
    def log_error(context_message, task)
        # logs exception tagged with the task name and timestamp
        # exception includes a class, message and backtrace
        # task, the rake task where the exception was thrown

        # more info: http://blog.bigbinary.com/2014/03/03/logger-formatting-in-rails.html
        # and http://guides.rubyonrails.org/debugging_rails_applications.html#tagged-logging
        logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
        logger.tagged("PRAXIS UPDATE", task.timestamp){
          Rails.logger.info context_message
         }
    end

    ##
    # sends a slack alert
    # msg(string) the text of the message to send
    def slack_alert msg

      payload = {
        :text => msg
      }.to_json

      cmd = "curl -X POST --data-urlencode 'payload=#{payload}' #{SECRET['SLACK_WEBHOOK']}"
      system cmd
    end
    send_emails = args[:send_emails] == 'true'

    url = 'https://datamanager.ets.org/edmwebservice/edmpraxis.wsdl'

    user_name = SECRET["PRAXIS_UN"]
    pw = SECRET["PRAXIS_PW"]

    client = Savon.client(wsdl: url)

    print "fetching all available dates..."
    get_these_dates = missing_report_dates(client, user_name, pw)

    fail("no new praxis reports!") if get_these_dates.empty?

    puts "-> done!"

    summary_data = []

    errors = []

    get_these_dates.each do |d|  #d: date string, format => %m/%d/%Y
      score_report = fetch_score_report(client, user_name, pw, d)
      puts "processing #{d}"
      root = score_report.root
      reports = root.xpath("scorereport")

      date_obj = DateTime.strptime(d, "%m/%d/%Y")
      report_objects = []

      begin
        ActiveRecord::Base.transaction do
          reports.each do |report|  # one scorereport per student
            report_obj = PraxisScoreReport.new report
            report_objects << report_obj
            puts "writing reults for #{report.last_name}, #{report.first_name}"
            report_obj.write_tests
          end # reports loop

          # all reports processed with no errors
          puts "finished processing report for #{d}"

          # add praxis_update record
          PraxisUpdate.create!({:report_date => date_obj})

          # send the emails on reports
          if (date_obj >= 30.days.ago) && (send_emails)
            report_objects.each do |r|
              r.email_created if r.stu.present?
            end
          else
            puts "email not sent for #{r.last_name}, #{r.first_name}"
          end

        end # transaction

      rescue Exception => e
        puts e.backtrace
        puts e.message
        puts 'rolling back...'
        slack_alert e.message
      end

    end # date loop

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

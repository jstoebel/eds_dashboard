require 'base64'
task :update_praxis => :environment do
    url = 'https://datamanager.ets.org/edmwebservice/edmpraxis.wsdl'

    user_name = Base64.encode64 "stoebelj"
    pw = Base64.encode64 "???"

    client = Savon.client(wsdl: url, log: true, logger: Rails.logger, log_level: :debug)
    response = client.call(:get_reporting_dates, message: {"UserName" => user_name, "Password" => pw })

    dates = Base64.decode64 response.body[:get_reporting_dates_response][:get_reporting_dates_result]
    puts dates

end
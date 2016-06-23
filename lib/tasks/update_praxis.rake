require 'base64'
task :update_praxis => :environment do
    url = 'https://datamanager.ets.org/edmwebservice/edmpraxis.wsdl'

    user_name = ENV["PRAXIS_UN"]
    pw = ENV["PRAXIS_PW"]

    client = Savon.client(wsdl: url)
    response = client.call(:get_reporting_dates, message: {"clientUserId" => user_name, "clientPassword" => pw })

    dates = Base64.decode64 response.body[:get_reporting_dates_response][:get_reporting_dates_result]

end
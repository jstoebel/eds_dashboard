require 'dbi'

task :banner_update => :environment do

    DBI.connect("DBI:OCI8:bannerdbrh.berea.edu:1521/rhprod", ENV["BANNER_UN"], ENV["BANNER_PW"]) do |dbh|
        sql = "SELECT * FROM saturn.szvedsd WHERE SZVEDSD_FILTER_TERM = 201512" 
        
        dbh.select_all(sql) do |row|
            puts row["SZVEDSD_ID"]
        end

    end
end
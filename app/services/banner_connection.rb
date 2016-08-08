require 'dbi'

class BannerConnection

  def initialize term
    #term(int) the banner term to search for.
    @term = term
  end

  def get_results
    puts "Running the real get_results"
    DBI.connect("DBI:OCI8:bannerdbrh.berea.edu:1521/rhprod", SECRET["BANNER_UN"], SECRET["BANNER_PW"]) do |dbh|
      sql = "SELECT * FROM saturn.szvedsd WHERE SZVEDSD_FILTER_TERM=#{@term}"
      return dbh.select_all(sql)
    end
  end

end

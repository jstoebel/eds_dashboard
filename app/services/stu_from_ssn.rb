require 'dbi'

class StuFromSsn
  # attr_reader :ssn

  def initialize(ssn)
    @ssn = ssn

  end

  def get_result
    DBI.connect("DBI:OCI8:bannerdbrh.berea.edu:1521/rhprod",
      SECRET["BANNER_UN"],
      SECRET["BANNER_PW"]) do |dbh|
        sql = "SELECT * FROM saturn.szvedsd SZVEDSD_SSN = ?"
        return dbh.select_all(sql, ssn)
      end
  end

end

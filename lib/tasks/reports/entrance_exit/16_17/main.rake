# Entrance/Exit report for 16_17
# NOT FUTURE PROOF!
# assumptions
# => running in fall 17

require 'csv'

task :entrance_exit_16_17 => :environment do

  ##
  # gender(str)
  # returns the gender code defined by EPSB
  def gender_code gender
    
    case gender.downcase
    when 'female'
      return '93'
    when 'male'
      return '94'
    else
      return '2177'
    end

  end

  ##
  # stu student object
  # can be multiple ethnicities seperated by a '; ' in which case use the first
  # returns the ethnicity code defined by EPSB
  def ethnicity_code stu

    return '19' if stu.hispanic

    first_race = stu.race.split('; ')[0]
    case first_race
    when 'White'
      return '20'
    when 'Black or African American'
      return '18'
    when 'American Indian or Alaskan Native'
      return '16'
    when 'Asian'
      return '17'
    when 'Native Hawaiian or Other Pacific Islander'
      return '17'
    else
      return '584'
    end
  end

  def major_code 
    # education general 13.01
  end

  cols = %w(EPSBID
            SSN
            studentID
            Title
            FirstName
            MiddleName
            LastName
            Suffix
            email
            DateofBirth
            StudentGender
            Ethnicity
            PhoneNumber
            CurrentAddress1
            CurrentAddress2
            ZipCode
            City
            PermanentAddress1
            PermanentAddress2
            PermanentZipCode
            PermanentCity
            ProgramCode1
            CertificateCode
            AdmissionDate
            EstimateGradDate
            CummulativeGPA
            Last30HoursGPA
            HoursCompleted
            GREVerbalCode
            GREVerbalScore
            GREVerbalDate
            GREQuantativeCode
            GREQuantativeScore
            GREQuantativeDate
            GRAnalyticalCode
            GRAnalyticalScore
            GRAnalyticalDate
            ExitDate
            ExitGPA
            Last60HoursExitGPA
            ExitReason
            DegreeDate
            Major
            Minor
            CountryCode
            StateCode)

  ay_start = Date.new(2016, 9, 1)
  ay_end = Date.new(2017, 8, 31)

  input_records = [] # adm_tep records
  output_records = []

  # entrances in this ay
  AdmTep
    .where({TepAdmit: true})
    .where('TEPAdmitDate >= ?', ay_start)
    .each {|e| input_records << e}

  # exits in this ay
  ProgExit
    .where('ExitDate >= ?', ay_start)
    .select{|e| e.adm_tep.TEPAdmitDate.present?}
    .each {|e| input_records << e.adm_tep}

  input_records.each do |entrance|
    stu = entrance.student
    row = ActiveSupport::OrderedHash.new

    # get ssn and dob
    stu_in_banner = Banner.by_bnum stu.Bnum
    ssn = stu_in_banner.szvedsd_ssn
    dob = stu_in_banner.szvedsd_dob

    date_format = '%m-%d-%Y'
    prog_exit = entrance.prog_exits.first # could be nil!
    row.merge!({
      'EPSBID' => nil,
      'SSN' => ssn,
      'studentID' => stu.Bnum,
      'Title' => nil,
      'FirstName' => stu.FirstName,
      'MiddleName' => nil,
      'LastName' => stu.LastName,
      'Suffix' => nil,
      'email' => stu.Email,
      'DateofBirth' => dob.strftime(date_format),
      'StudentGender' => gender_code(stu.gender),
      'Ethnicity' => ethnicity_code(stu),
      'PhoneNumber' => nil,
      'CurrentAddress1' => '101 Chestnut St',
      'CurrentAddress2' => '',
      'ZipCode' => '40404',
      'City' => 'Berea',
      'PermanentAddress1' => '101 Chestnut St',
      'PermanentAddress2' => nil,
      'PermanentZipCode' => '40404',
      'PermanentCity' => 'Berea',
      'ProgramCode1' => entrance.program.ProgCode,
      'CertificateCode' => entrance.program.license_code,
      'AdmissionDate' => entrance.TEPAdmitDate.strftime(date_format),
      'EstimateGradDate' => '12-15-2018',
      'CummulativeGPA' => entrance.GPA,
      'Last30HoursGPA' => entrance.GPA_last30,
      'HoursCompleted' => entrance.EarnedCredits,
      'GREVerbalCode' => nil,
      'GREVerbalScore' => nil,
      'GREVerbalDate' => nil,
      'GREQuantativeCode' => nil,
      'GREQuantativeScore' => nil,
      'GREQuantativeDate' => nil,
      'GRAnalyticalCode'  => nil,
      'GRAnalyticalScore' => nil,
      'GRAnalyticalDate' => nil,
      'ExitDate' => prog_exit.andand.ExitDate.andand.strftime(date_format),
      'ExitGPA' => prog_exit.andand.GPA,
      'Last60HoursExitGPA' => prog_exit.andand.GPA_last60,
      'ExitReason' => prog_exit.andand.exit_code.andand.ExitCode,
      'DegreeDate' => nil,
      'Major' => '13.01',
      'Minor' => nil,
      'CountryCode' => nil,
      'StateCode' => nil,
    })
    output_records << 

  end
  # write to file
  file_loc_arr = __FILE__.split(File::SEPARATOR)
  file_loc_arr[-1] = "entrance_exit_16_17_raw.csv"

  CSV.open(file_loc_arr.join(File::SEPARATOR), "wb") do |csv|
    csv << output_records.first.keys
    output_records.each do |hash|
      csv << hash.values
    end
  end
end
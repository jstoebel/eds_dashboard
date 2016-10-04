
# NOTE: This script is not future proof!
# it assumes that
# => it is being run in fall 16,
# => before anyone was admitted or exited

require 'csv'


task :title2_fall15 => :environment do

  cols = [
    "AI-CDE",
    "PROGRAM",
    "CATEGORY",
    "LAST-NAME",
    "LAST-NAME2",
    "LAST-NAME3",
    "LAST-NAME4",
    "LAST-NAME5",
    "FIRST-NAME",
    "MI",
    "DOB",
    "SSN",
    "CAND-ID",
    "CAND-ID2",
    "CAND-ID3",
    "CAND-ID4",
    "STREET-ADDR",
    "CITY",
    "ST",
    "LICENSE",
    "LICENSE2",
    "LICENSE3",
    "LICENSE4",
    "LICENSE5",
    "LICENSE6",
    "LICENSE7",
    "LICENSE8",
    "LICENSE9",
    "LICENSE10"
  ]

  ay_start = Date.new(2015, 9, 1)
  ay_end = Date.new(2016, 8, 31)

  # BRUTE FORCE SOLUTION: LESS HARD TO REASON ABOUT
  students = []
    # :stu => the AR student object
    # :category => the cateogry they fall under for Title II

  # 1 student was admitted in ay
  # category:
  students += Student.joins(:adm_tep).where("TEPAdmit=1 and TEPAdmitDate >= ? and TEPAdmitDate <= ?", ay_start, ay_end).map{|s| {:stu => s, :category => "1 or 2"}}

  # 2 student was exited in ay
  students += Student.joins(:prog_exits).where("ExitDate >= ? and ExitDate <= ?", ay_start, ay_end).map{|s| {:stu => s, :category => "3"}}

  # 3 student was admitted prior to ay and has no exits
  with_open_progs = Student.all.select{|s| s.open_programs.present?}
  with_open_progs.each do |s|
    students << {:stu => s, :category => "1 or 2"} if !students.include?(s)
  end

  #create array of hashes
  stu_hashes = []
  students.each do |stu_result|
    stu = stu_result[:stu]

    stu_hash = ActiveSupport::OrderedHash.new

    stu_hash.merge!({
      "AI-CDE" => "1060",
      "PROGRAM" => "R",
      "CATEGORY" => stu_result[:category],
    })

    stu.last_names.each_with_index do |lname, i|
      field_name = i == 0 ? "LAST-NAME" : "LAST-NAME#{i+1}"
      stu_hash[field_name] = lname.last_name
    end

    stu_hash.merge!({
      "FIRST-NAME" => stu.FirstName,
      "MI" => stu.MiddleName.andand[0],
      "DOB" => nil,
      "SSN" => nil,
      "CAND-ID" => stu.Bnum,
      "CAND-ID2" => nil,
      "CAND-ID3" => nil,
      "CAND-ID4" => nil,
      "STREET-ADDR" => "101 Chestnut St.",
      "CITY" => "Berea",
      "ST" => "KY"
    })

    # add programs
    stu.programs.each_with_index do |prog, i|
      field_name = i == 0 ? "LICENSE" : "LICENSE#{i+1}"
      stu_hash[field_name] = prog.license_code
    end

    stu_hashes << stu_hash

  end

  file_loc_arr = __FILE__.split(File::SEPARATOR)
  file_loc_arr[-1] = "titleII_fall16.csv"

  CSV.open(file_loc_arr.join(File::SEPARATOR), "wb") do |csv|
    csv << stu_hashes.first.keys
    stu_hashes.each do |hash|
      csv << hash.values
    end
  end
end
#
# def admited_in_ay(stu, ay)
#   # does the student have an admission in AY
#   puts "admitted_in_ay" if stu.adm_tep.where("TEPAdmitDate > ?", ay).present?
#   return stu.adm_tep.where("TEPAdmitDate > ?", ay.to_s).present?
# end
#
# def exited_in_ay(stu, ay)
#   # does the student have an exit in AY?
#   return stu.prog_exits.where("ExitTerm > ?", ay).present?
# end
#
# def has_open_programs(stu)
#   # does the student have any open programs?
#   # puts "has_open_programs" if stu.open_programs.present?
#   puts "has open programs" if stu.open_programs.present?
#   return stu.open_programs.present?
# end

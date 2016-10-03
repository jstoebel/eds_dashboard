
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

  # BRUTE FORCE SOLUTION: LESS HARD TO REASON ABOUT

  # admited_in_ay = lambda {|stu| stu.adm_tep.where("TEPAdmitDate > ?", ay).present?}
  # exited_in_ay = lambda {|stu| stu.prog_exits.where("ExitTerm > ?", ay).present?}
  # has_open_programs = lambda{|stu| stu.open_programs.present?}

  stus = []
  Student.all.each do |stu|
    if has_open_programs(stu) ||
      admited_in_ay(stu, ay_start) ||
      exited_in_ay(stu, ay_start)

      stus << stu
    end

  end

  puts stus.size

  # SQL SOLUTION
  # students_tbl = Student.arel_table
  # adm_tep_tbl = AdmTep.arel_table
  # prog_exit_tbl = ProgExit.arel_table

  # query = students_tbl
  #           .join(adm_tep_tbl).on(students_tbl[:id].eq(adm_tep_tbl[:student_id]))
  #           .join(prog_exit_tbl).on(students_tbl[:id].eq(prog_exit_tbl[:student_id]))

  # query = adm_tep_tbl[:TEPAdmit].eq(true)
  #           .and(adm_tep_tbl[:TEPAdmitDate].gteq(ay_start))
  #             .or(prog_exit_tbl[:ExitDate].gteq(ay_start))
  #
  #
  # puts query.to_sql

end

def admited_in_ay(stu, ay)
  # does the student have an admission in AY
  puts "admitted_in_ay" if stu.adm_tep.where("TEPAdmitDate > ", ay).present?
  return stu.adm_tep.where("TEPAdmitDate > ", ay).present?
end

def exited_in_ay(stu, ay)
  # does the student have an exit in AY?
  return stu.prog_exits.where("ExitTerm > ?", ay).present?
end

def has_open_programs(stu)
  # does the student have any open programs?
  # puts "has_open_programs" if stu.open_programs.present?
  return stu.open_programs.present?
end

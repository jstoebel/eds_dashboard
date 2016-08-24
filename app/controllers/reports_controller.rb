# == Schema Information
#
# Table name: reports

class ReportsController < ApplicationController
    layout 'application'
    authorize_resource
    
    def index
        data = []
        students = Student.all
        students.each do |stu|
            record = {
                :Bnum => stu.Bnum,
                :name => stu.name_readable,
                :ProgramStatus => stu.prog_status,
                :Major1 => stu.CurrentMajor1,
                :Concentration1 => stu.Concentration1,
                :Major2 => stu.CurrentMajor2,
                :Concentration2 => stu.Concentration2
                :Minors => stu.CurrentMinors,
                :Taken227_228 => taken_227_228(stu)
            }
            
        end
    end
    
    private
    def taken_227_228(student)
        return student.transcripts.where(:course_code => ["EDS227", "EDS228"]).any?
    end
    
    def passed_227_228(student)
       return student.transcripts.where(:course_code => ["EDS227", "EDS228"] and :grade_pt => nil.present? ).any?
    end
    
end

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
                :Concentration1 => stu.concentration1,
                :Major2 => stu.CurrentMajor2,
                :Concentration2 => stu.concentration2,
                :Minors => stu.CurrentMinors,
                :Taken227_228 => taken_227_228(stu),
                :Passed_227_228 => passed_227_228(stu),
                :Latest_Completion_227 => complete_227(stu),
                :Latest_Completion_228 => complete_228(stu),
                :Latest_Term_EDS440_470 => term_EDS440_470(stu),
            }
            
        end
    end
    
    private
    def taken_227_228(student)
        return student.transcripts.where(:course_code => ["EDS227", "EDS228"]).any?
    end
    
    def passed_227_228(student)
       return student.transcripts.where(:course_code => ["EDS227", "EDS228"], :grade_pt => nil ).present?
    end
    
    def complete_227(student)
        return student.transcripts.where(:course_code => ["EDS227"]).banner_term.readable
    end
    
    def complete_228(student)
        return student.transcripts.where(:course_code => ["EDS228"]).banner_term.readable
    end
   
   def term_EDS440_470(student)
        return
    end
end

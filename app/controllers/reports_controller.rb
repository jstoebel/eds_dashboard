# == Schema Information
#
# Table name: reports

class ReportsController < ApplicationController
    layout 'application'
    authorize_resource

    def index
        @data = []
        students = Student.all
        students.each do |stu|
            record = { # data that will go into the exceel spreadsheet, eventually
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
            @data.push record
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
        # looks at the student's transcript where the course code is EDS227, orders it by the taken term and finds the last (latest) one
        course = student.transcripts.where(:course_code => ["EDS227"]).order(:term_taken).last
        if course.nil?
            return nil
        else
            return course.banner_term.readable #returns the term taken
        end
    end

    def complete_228(student)
        courses = student.transcripts.where(:course_code => ["EDS228"]).order(:term_taken).last
        if courses.nil?
            return nil
        else
            return courses.banner_term.readable
        end
    end

   def term_EDS440_470(student)
       course_taken = student.transcripts.where(:course_code => ["EDS440", "EDS470"]).order(:term_taken).last
       if course_taken.nil?
           return nil
       else
           return course_taken.banner_term.readable
       end
   end


end

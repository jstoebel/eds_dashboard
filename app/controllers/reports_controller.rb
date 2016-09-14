# == Schema Information
#
# Table name: reports

class ReportsController < ApplicationController
    layout 'application'

    def index
        @data = []
        students = Student.all
        students.each do |stu|
            authorize! :read, stu
            record = { # data that will go into the exceel spreadsheet, eventually
                :Bnum => stu.Bnum,
                :name_readable => stu.name_readable,
                :prog_status => stu.prog_status,
                :CurrentMajor1 => stu.CurrentMajor1,
                :concentration1 => stu.concentration1,
                :CurrentMajor2 => stu.CurrentMajor2,
                :concentration2 => stu.concentration2,
                :CurrentMinors => stu.CurrentMinors,
                :Taken227_228 => taken_227_228(stu),
                :Passed_227_228 => passed_227_228(stu),
                :Latest_Completion_227 => complete_227(stu),
                :Latest_Completion_228 => complete_228(stu),
                :Latest_Term_EDS440_479 => term_EDS440_479(stu),
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
        # if student hasn't taken EDS 227 returns nil
        course = student.transcripts.where(:course_code => ["EDS227"]).order(:term_taken).last
        return course.andand.banner_term.andand.readable #returns the term taken
    end

    def complete_228(student)
        courses = student.transcripts.where(:course_code => ["EDS228"]).order(:term_taken).last
        return courses.andand.banner_term.andand.readable
    end

   def term_EDS440_479(student)
       course_taken = student.transcripts.where(:course_code => ["EDS440", "EDS479"]).order(:term_taken).last
       return course_taken.andand.banner_term.andand.readable
   end


end

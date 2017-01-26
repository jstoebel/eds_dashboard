# == Schema Information
#
# Table name: reports

class ReportsController < ApplicationController
    layout 'application'

    def index
        authorize! :report, Student
        @data = []
        students = Student.all
        students.each do |stu|
            # filter out students who are not actively enrolled and

            if stu.EnrollmentStatus.include? 'WD'
                # skip if student has withdrawn and latest withdraw was more
                # than 1 year ago

                latest_w_date = stu.last_withdraw.andand.EndDate # may be nil!
                if latest_w_date.present? &&
                    latest_w_date < 1.year.ago &&
                    stu.EnrollmentStatus != "Active Student"

                    next
                end
            elsif stu.EnrollmentStatus != "Active Student"
                # if they aren't withdrawn, skip if not active student
                next
            end


            record = { # data that will go into the excel spreadsheet, eventually
                :Bnum => stu.Bnum,
                :name_readable => stu.name_readable,
                :prog_status => stu.prog_status,
                :EnrollmentStatus => stu.EnrollmentStatus,
                :Classification => stu.Classification,
                :CurrentMajor1 => stu.CurrentMajor1,
                :concentration1 => stu.concentration1,
                :CurrentMajor2 => stu.CurrentMajor2,
                :concentration2 => stu.concentration2,
                :CurrentMinors => stu.CurrentMinors,
                :Latest_Term_EDS150 => term_EDS150(stu),
                :Taken227_228 => taken_227_228(stu),
                :Passed_227_228 => passed_227_228(stu),
                :Latest_Completion_227 => complete_227(stu),
                :Latest_Completion_228 => complete_228(stu),
                :Latest_Term_EDS440_479 => term_EDS440_479(stu),
                :ProgName => student_program(stu),
                :advisors => advisors(stu)
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

    def term_EDS150(student)
        course_taken = student.transcripts.where(:course_code => ["EDS150"]).order(:term_taken).last
        return course_taken.andand.banner_term.andand.readable
    end

    def term_EDS440_479(student)
       course_taken = student.transcripts.where(:course_code => ["EDS440", "EDS479"]).order(:term_taken).last
       return course_taken.andand.banner_term.andand.readable
    end

    def student_program(student)
        program_name = student.programs.map{|t| "#{t.EDSProgName}"}.join("; ")
        return program_name.andand
    end

    def advisors(student)
      student.tep_advisors.map{|a| "#{a.first_name} #{a.last_name}"}.join('; ')
    end

end

# == Schema Information
#
# Table name: reports

class ReportsController < ApplicationController
    layout 'application'

    def index
        # the general all students report
        authorize! :report, Student
        @data = []
        students = Student.all

        # maps header names to attributes
        @header_mappings = [
          ["B#", :Bnum],
          ["Name", :name_readable],
          ["Prog Status", :prog_status],
          ["Enrollment Status", :EnrollmentStatus],
          ["Classification", :Classification],
          ["Program(s)", :ProgName],
          ["Major 1", :CurrentMajor1],
          ["Conc 1", :concentration1],
          ["Major 2", :CurrentMajor2],
          ["Conc 2", :concentration2],
          ["Minors", :CurrentMinors],
          ["EDS150", :Latest_Term_EDS150],
          ["Taken 227/228", :Taken227_228],
          ["Completed 227/228", :Passed_Completion_227],
          ["Term completing 227", :Latest_Completion_227],
          ["Term completing 227", :Latest_Completion_228],
          ["EDS440 or EDS470", :Latest_Term_EDS440_479],
          ["Advisors", :advisors]
        ]
        if current_user.is?("admin")
            @header_mappings.push(["GPA", :gpa])
        end
        students.each do |stu|
            # filter out students who are not actively enrolled and

            if stu.EnrollmentStatus.nil?
                next
            elsif stu.EnrollmentStatus.include? 'WD'
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


            record = { # data that will go into the table
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
            
            # only admins can see GPA!
            if current_user.is?("admin")
                begin
                    record[:gpa] = stu.gpa
                rescue NoMethodError => e
                    Rails.logger.warn e.message
                    Rails.logger.warn e.backtrace

                    record[:gpa] = nil
                end
            end

            @data.push record
        end
    end

    def need_apply_tep
        # display students needing to apply to the TEP
        authorize! :report, Student
        @current_term = BannerTerm.current_term({:exact => false, :plan_b => :forward})
        @stus = Student.need_apply
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

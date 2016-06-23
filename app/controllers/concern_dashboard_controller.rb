class ConcernDashboardController < ApplicationController

    def index

        @student = Student.find params[:student_id]

        @areas = ["praxis", "issues"]

        outcomes = {
            nil => {:status => "info", :glyph => "question-sign"},
            true => {:status => "success", :glyph => "ok-sign"}, 
            false => {:status => "danger", :glyph => "warning-sign"},
        }

        @areas.each do |area|
            #get the status in this area
            status = self.send("#{area}_check", @student)
            outcome = outcomes[status]
            outcome.each{|k,v| instance_variable_set("@#{area}_#{k}", v)}
        end

    end

    private

    def praxis_check(stu)
        if stu.praxis_results.blank?
            return nil
        else
            return stu.praxisI_pass
        end
    end

    def issues_check(stu)

        return !    stu.issues.select{|i| i.Open}.present?


    end
end

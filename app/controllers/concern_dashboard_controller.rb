class ConcernDashboardController < ApplicationController

    def index
        @student = Student.find params[:student_id]

        if @student.praxis_results.blank?
            @praxis_status = "info"
            @praxis_glyph = "question-sign>"
            @praxis_msg = "not yet attempted"
        elsif @student.praxisI_pass
            @praxis_status = "success"
            @praxis_glyph = "ok-sign"
            @praxis_msg = "passed"
        else 
            @praxis_status = "danger"
            @praxis_glyph = "alert"
            @praxis_msg = "not yet passed"
        end



    end
end

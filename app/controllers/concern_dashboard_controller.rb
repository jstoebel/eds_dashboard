class ConcernDashboardController < ApplicationController

    def index

        @student = Student.find params[:student_id]
        authorize! :be_concerned, @student

        @areas = ["praxis", "issues"]#, "issues"]

        #swap the key out for its value hash.
        outcomes = {
            nil => {:alert_status => "info", :glyph => "question-sign"},
            true => {:alert_status => "success", :glyph => "ok-sign"}, 
            false => {:alert_status => "danger", :glyph => "warning-sign"},
        }

        @concerns = []

        @areas.each do |area|
            #get the status in this area
            args = self.send("#{area}_check", @student)
            if args.present?
                outcome = outcomes[args.delete(:outcome)]
                merged = args.merge outcome
                @concerns << merged
            end

        end

    end

    private

    def praxis_check(stu)

        args = {:title => "Praxis I", :link => student_praxis_results_path(stu.id), :link_title => "View Praxis Results", :link_num => stu.praxis_results.size}
        if stu.praxis_results.blank?
            return args.merge({:outcome => nil, :msg => "This student has not taken the Praxis I"})
        elsif stu.praxisI_pass
            #passed praxis!
            return args.merge({:outcome => true, :msg => "This student has passed the Praxis I"})
        else
            return args.merge({:outcome => false, :msg => "This student has not passed the Praxis I"})           
        end
    end

    def issues_check(stu)

        if stu.issues.select{|i| i.Open}.present?
            #student has open issues
            return {:title => "Advisor Notes", :link => student_issues_path(stu.id), :link_title => "View Advisor Notes", :link_num => stu.issues.open.size,
                :outcome => false, :msg => "This student has open advisor notes."

            }
        end
    end
end

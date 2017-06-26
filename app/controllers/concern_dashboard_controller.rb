class ConcernDashboardController < ApplicationController

    def index
        # displays all concerns for a paticular student
        
        
        @student = Student.find params[:student_id]
        authorize! :be_concerned, @student

        #define what areas should be examined here. They name should corispond to a method below.
        areas = [:praxis, :issues]

        # based on the value that the method returns, this determines some standard values
        # for output.
        outcomes = {
            nil => {:alert_status => "info", :glyph => "question-sign"},
            true => {:alert_status => "success", :glyph => "ok-sign"},
            false => {:alert_status => "danger", :glyph => "warning-sign"},
        }

        @concerns = {}

        areas.each do |area|
            #get the status in this area
            args = self.send("#{area}_check", @student)
            if args.present?
                outcome = outcomes[args.delete(:outcome)] # pop this key
                merged = args.merge outcome # swap it for the right values in outcomes
                @concerns[area] = merged #load into instance variable
            end

        end

    end

    private
    
    
    # concern checkers. Each method below defines how to determine a student's
    # status in a single area. Each well return a hash with the following attributes
    
      # :outcome(bool)(required) determining if the area is a concern
      # :msg(str)(required) the coorsponding message
      # :link(str): the url to view details on this area
      # :link_title(str): what the link should be displayed as
      # :link num(number like): if a badge should be displayed what number to use?
      
      
    def praxis_check(stu)

        args = {:title => "Praxis I", :link => student_praxis_results_path(stu.id), :link_title => "View Praxis Results", :link_num => stu.praxis_results.size}
        if stu.praxis_results.blank?
            #no praxis scores
            return args.merge({:outcome => nil, :msg => "This student has not taken the Praxis I"})
        elsif stu.praxisI_pass
            #passed praxis!
            return args.merge({:outcome => true, :msg => "This student has passed the Praxis I"})
        else
            #not passing!
            return args.merge({:outcome => false, :msg => "This student has not passed the Praxis I"})
        end
    end

    def issues_check(stu)

        if stu.issues.select{|i| i.open?}.present?
            #student has open issues
            return {:title => "Advisor Notes", :link => student_issues_path(stu.id), :link_title => "View Advisor Notes", :link_num => stu.issues.select{|i| i.open?}.size,
                :outcome => false, :msg => "This student has open advisor notes."

            }
        end
    end
end

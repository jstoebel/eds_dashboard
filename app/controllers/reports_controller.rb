# == Schema Information
#
# Table name: reports

class ReportsController < ApplicationController
    layout 'application'
    authorize_resource
    
    def index
        @report = Report.find params[:id]
        authorize! :read, @report
        @scores = @report.student_scores.select{|r| can? :read, r}
        authorize! :read, @scores
        respond_to do |format|
          format.html
          format.xls
        end
    end
    
    def show
       @report = Report.find params[:id]
       authorize! :show, @report
    end
    
    
end

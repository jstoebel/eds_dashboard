# == Schema Information
#
# Table name: reports

class ReportsController < ApplicationController
    layout 'application'
    authorize_resource
    
    def index
        @student = Student.all.by_last.current
        authorize! :show, @student
    end
    
end

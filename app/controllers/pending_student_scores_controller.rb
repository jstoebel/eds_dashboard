class PendingStudentScoresController < ApplicationController
    authorize_resource
    
    def index
        @pending = PendingStudentScore.all
        authorize! :read, @pending
    end
    
    def destroy
        @pending = PendingStudentScore.find(params[:id])
        if @pending.destroy?
            flash[:notice] = "Added student score"
        else
            flash[:notice] = "Unable to add student score"
        end
        render "index"
    end
end

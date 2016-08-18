class PendingStudentScoresController < ApplicationController
    authorize_resource
    
    def index
        @pending = PendingStudentScore.all
        authorize! :read, @pending
    end

end

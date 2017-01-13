class TranscriptsController < ApplicationController
    respond_to :html, :json

    def index
      stu = Student.find params[:student_id]
      authorize! :read, stu
      @transcripts = stu.transcripts
      render :json => @transcripts
    end
end

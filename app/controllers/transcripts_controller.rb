class TranscriptsController < ApplicationController
    respond_to :json

    def index
        # get all of students transcripts in current term
        term = BannerTerm.current_term(:exact => false, :plan_b => :forward)
        stu = Student.find params[:student_id]
        authorize! :read, stu
        transcripts = stu.transcripts.where(:term_taken => term.id)
        render :json => transcripts
    end
end

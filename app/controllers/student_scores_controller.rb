class StudentScoresController < ApplicationController

  def index

    @format_types = [:moodle, :qualtrics]
    # upload a student score


  end

  def import
    # process a file
    file = params[:file]
    file_format = params[:format]

    # process the file. Should return an array containing results of
    # processing each record

    # TODO: need the ability to distinguish between different assessments
    begin
      StudentScore.import_setup params[:file], params[:format]
    rescue => e
      flash[:notice] = e.message
      # catch problems with the file here
    end

    redirect_to student_scores_path
  end

end

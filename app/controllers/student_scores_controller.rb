class StudentScoresController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
    @format_types = StudentScore.format_types
    @assessments = Assessment.all.pluck :name
    # upload a student score
  end

  def import
    # process a file
    file = params[:file]
    file_format = params[:format]
    assessment = Assessment.find_by! :name => params[:assessment]
    "#{file_format.capitalize}ProcessorJob"
      .constantize
      .set(queue: 'urgent', wait: 5.seconds)
      .perform_now file.path, assessment

    flash[:notice] = "File recieved for processing. We'll post the results here when its done."
    redirect_to student_scores_path

    # # process the file. Should return an array containing results of
    # # processing each record
    #
    # # TODO: need the ability to distinguish between different assessments.
    # # user can provide the assessment name
    # begin
    #   msg = StudentScore.import_setup params[:file], params[:format], assessment
    #   flash[:notice] = msg
    # rescue => e
    #   flash[:notice] = "Error encountered. All imports rolled back." + e.message
    # end
    # redirect_to student_scores_path

  end

end

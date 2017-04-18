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

    # move the attached file so it will remain when the request finishes.
    persisted_path = "app/jobs/#{file.original_filename}"
    FileUtils.copy_file file.path, persisted_path

    file_format = params[:format]
    assessment = Assessment.find_by! :name => params[:assessment]
    "#{file_format.capitalize}ProcessorJob"
      .constantize
      .delay
      .perform_now persisted_path, assessment

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

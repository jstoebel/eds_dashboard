class StudentScoresController < ApplicationController
  include ActionView::Helpers::TextHelper

  ##
  # display scores
  # currently we are only displaying scores by StudentScoreUpload
  def index
    ssu = StudentScoreUpload.find params[:student_score_upload_id]
    @scores = ssu.student_scores
  end

  def upload
    # upload a student score
    @format_types = StudentScore.format_types
    @assessments = Assessment.all.pluck :name
    @uploads = StudentScoreUpload.all.order :created_at
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
    redirect_to upload_student_scores_path
  end
end

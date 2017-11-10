class StudentScoreUploadsController < ApplicationController
  include ActionView::Helpers::TextHelper

  load_and_authorize_resource

  ##
  # display scores
  # currently we are only displaying scores by StudentScoreUpload
  def show
    @scores = @student_score_upload.student_scores
  end

  def upload
    # upload a student score
    @format_types = StudentScore.format_types
    @assessments = Assessment.all.pluck :name
    @uploads = StudentScoreUpload.all.order :created_at
  end

  def import
    # process a file
    authorize! :manage, StudentScore
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
    redirect_to upload_student_score_uploads_path
  end

  def destroy
    StudentScoreUpload.transaction do
      @student_score_upload.destroy!
    end
    redirect_to upload_student_score_uploads_path
  end

end

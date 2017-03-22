class StudentScoresController < ApplicationController
  include ActionView::Helpers::TextHelper

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

    # TODO: need the ability to distinguish between different assessments.
    # user can provide the assessment name
    begin
      student_count, score_count = StudentScore.import_setup params[:file], params[:format]
      flash[:notice] = "Successfully imported #{pluralize score_count, 'score'}, #{pluralize student_count, 'student'}"
    rescue => e
      flash[:notice] = "Error encountered. All imports rolled back." + e.message
    end

    redirect_to student_scores_path
  end

end

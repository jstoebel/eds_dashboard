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


    # process the file. Should return an array containing results of
    # processing each record

    # TODO: need the ability to distinguish between different assessments.
    # user can provide the assessment name
    begin
      student_count, score_count = StudentScore.import_setup params[:file], params[:format], assessment
      flash[:notice] = "Successfully imported #{pluralize score_count, 'score'}, #{pluralize student_count, 'student'}"
    rescue => e
      flash[:notice] = "Error encountered. All imports rolled back." + e.message
    end
    redirect_to student_scores_path
    
  end

end

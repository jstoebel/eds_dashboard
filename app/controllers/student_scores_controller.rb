class StudentScoresController < ApplicationController
  authorize_resource

  def index
    @version = AssessmentVersion.find(params[:assessment_version_id])
    authorize! :read, @version
    #TODOadd sorted here after defining scope
    @score = @version.student_scores.select{|r| can? :read, r}
    authorize! :read, @score
    respond_to do |format|
      format.html
      format.csv {send_data @score.to_csv}
      format.xls
    end
  end
  
  def new
    @versions = AssessmentVersion.all
    authorize! :manage, @versions
    @score = StudentScore.new
    authorize! :manage, @score
  end
  
  def show
    @version = AssessmentVersion.find(params[:assessment_version_id])
    authorize! :read, @versions
    # TODO finish show
  end
  
  def import
    @score = StudentScore.import_create(params[:file])
    flash[:alert] = "Scores Uploaded Successfully"
    redirect_to assessment_version_student_scores_path(@score.first.assessment_version_id)
    
    # spreadsheet = open_spreadsheet(file)
    # header = spreadsheet.row(1)
    # (2..spreadsheet.last_row).each do |i|
    #   [spreadsheet.row(i)]
    # end
    #   version_update = find_by_id(row["B#"]) || new
    #   version_update.attributes = row.to_hash.slice(*accessible_attributes)
    #   version_update.save!
  end
  
  private
  
end
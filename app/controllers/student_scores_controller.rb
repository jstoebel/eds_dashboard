class StudentScoresController < ApplicationController
  authorize_resource

  def index
    @version = AssessmentVersion.find(params[:assessment_version_id])
    authorize! :read, @version
    #TODOadd sorted here after defining scope
    @scores = @version.student_scores.select{|r| can? :read, r}
    authorize! :read, @scores
    respond_to do |format|
      format.html
      format.csv {send_data @scores.to_csv}
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
    #import_create method returns list with ver_id as ver_and_matches[0]
    #if exact name is not found, list of possible students is returned as [1]
    created = StudentScore.import_create(params[:file])
    @ver_id = created[:ver]
    @scores = created[:scores]
    @pending = created[:pending]
    render 'scores_created'
  end
  
  private
  
  
  
end
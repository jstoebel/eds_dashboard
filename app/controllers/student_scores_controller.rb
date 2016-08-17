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
    ver_and_matches = StudentScore.import_create(params[:file])
    if ver_and_matches[1] != nil
      puts ver_and_matches
      @score_info = ver_and_matches
      render 'select_stu'
      #StudentScore.(params[:])
    end
    flash[:alert] = "Scores Uploaded Successfully"
    redirect_to :action => "index", :assessment_version_id => ver_and_matches[0]
  end
  
  private
  
  
  
end
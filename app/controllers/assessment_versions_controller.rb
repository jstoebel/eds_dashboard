class AssessmentVersionsController < ApplicationController
  authorize_resource
  
  def index
    #shows all versions of a particular assessment
    if params["assessment_id"]   #we only want versions of this assessment
      @version = AssessmentVersion.where(assessment_id: params["assessment_id"]).select {|r| can? :read, r } 
    else
      @version = AssessmentVersion.all  #.select {|r| can? :read, r } 
    end
    authorize! :read, @version
  end
  
  def new
    form_details
    @version = AssessmentVersion.new
    authorize! :manage, @version
  end

  def create
    @version = AssessmentVersion.new
    authorize! :manage, @version
    @version.update_attributes(version_params)
    if @version.save
      flash[:notice] = "Created Version #{@version.version_num} of 
        #{Assessment.find(@version.assessment_id).name}"
      redirect_to(assessment_versions_path)
    else
      render('new')
    end
  end

  def edit
    form_details
    @version = AssessmentVersion.find(params[:id])
    authorize! :manage, @version
  end

  def update
    @version = AssessmentVersion.new
    authorize! :manage, @version
    @version.update_attributes(version_params)
    if @version.save
      flash[:notice] = "Updated Version #{@version.version_num} of 
        #{Assessment.find(@version.assessment_id).name}"
      redirect_to(assessment_version_path)
    else
      render('edit')
    end
  end
  
  def delete
    
  end

  def destroy
  end
  
  def choose
    #display versions for an assessment.
	  @assessment = params[:assesment][:assessment_versions]
	  redirect_to(assessment_versions_index_path(@assessment))
  end

  private
  def version_params
    params.require(:assessment_version).permit(:assessment_id, :assessment_items, :version_num)
  end
  
  def form_details
    @assessments = Assessment.all
    @items = AssessmentItem.all
  end
end


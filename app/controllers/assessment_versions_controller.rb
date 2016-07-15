class AssessmentVersionsController < ApplicationController
  authorize_resource
  
  def index
    #shows all versions of a particular assessment
    if params["assessment_id"]   #we only want versions of this assessment
      @assessment = Assessment.find(params[:assessment_id])
      @version = @assessment.assessment_versions.sorted.select {|r| can? :read, r }
    else
      @version = AssessmentVersion.all.sorted.select {|r| can? :read, r } 
    end
    authorize! :read, @version
  end
  
  def new
    @version = AssessmentVersion.new
    @assessment = Assessment.find(params[:assessment_id])
    authorize! :manage, @version
    form_setup
  end

  def create
    #puts params.inspect #DELETE ME!
    
    @version = AssessmentVersion.new
    authorize! :manage, @version
    @version.update_attributes(new_params)
    form_setup
    if @version.save
      flash[:notice] = "Created Version #{@version.version_num} of 
        #{Assessment.find(@version.assessment_id).name}"
      redirect_to(assessment_assessment_versions_path(:assessment_id))
    else
      render('new')
    end
  end

  def edit
    @version = AssessmentVersion.find(params[:id])
    authorize! :manage, @version
    form_setup
  end

  def update
    ###Update may not go in version. Updating associated
    # objects rather than attributes, so may belong in habtm table.
    @version = AssessmentVersion.find(params[:id])
    authorize! :manage, @version
    @version.update_attributes(update_params)
    if @version.save
      flash[:notice] = "Updated Version #{@version.version_num} of 
        #{Assessment.find(@version.assessment_id).name}"
      redirect_to(assessment_versions_path)
    else
      render('edit')
    end
  end
  
  def delete
    @version = AssessmentVersion.find(params[:assessment_version_id])
    authorize! :manage, @version
  end
  
  def destroy
    @version = AssessmentVersion.find(params[:id])
    authorize! :manage, @version
    if @version.has_scores == false
      @version.destroy
      flash[:notice] = "Record deleted successfully"
    else
      flash[:notice] = "Record cannot be deleted"
    end
    redirect_to(assessment_assessment_versions_path(@version.assessment_id))
  end
  
  def choose
    #display versions for an assessment.
	  @assessment = params[:assesment][:assessment_versions]
	  redirect_to(assessment_versions_index_path(@assessment))
  end

  private
  def new_params
    params.require(:assessment_version).permit(:assessment_id) 
  end
  
  def update_params
    params.require(:assessment_version).permit(:assessment_items)
  end
  
  def form_setup
    @assessments = Assessment.all
    @items = AssessmentItem.all
  end
end


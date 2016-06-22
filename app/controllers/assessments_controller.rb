class AssessmentsController < ApplicationController
  authorize_resource
  
  def index
    @assessment = Assessment.all    
    authorize! :read, @assessment
  end

  def new
    @assessment = Assessment.new
    authorize! :manage, @assessment
  end

  def create
    @assessment = Assessment.new
    authorize! :manage, @assessment  
    @assessment.assign_attributes(assessment_params)
  end

  def edit
    @assessment = Assessment.find(params[:id])
    authorize! :manage, @assessment
  end

  def update
    @assessment = Assessment.find(params[:id])
    authorize! :manage, @assessment  
    @assessment.update_attributes(assessment_params)
    if @assessment.save
      flash[:notice] = "Updated Assessment #{@assessment.Name}."
      redirect_to(assessment_index_path)
    else
      render ('edit')
    end
  end

  def delete
    @assessment = Assessment.find(params[:id])
    authorize! :manage, @assessment
  end
  
  def destroy
    @asssessment = Assessment.find(params[:id])
    authorize! :manage, @assessment
    if @assessment.AssessmentVersion.StudentScore == nil
      @assessment.destroy
      flash[:notice] = "Record deleted successfully"
    else
      flash[:notice] = "Record cannot be deleted"
    end
    redirect_to(assessment_index_path)
  end
  
  private
  
  def assessment_params
    params.require(:assessment).permit(:name, :description)
  end
end

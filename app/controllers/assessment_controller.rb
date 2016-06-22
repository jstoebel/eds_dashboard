class AssessmentController < ApplicationController
  authorize_resource
  
  def index
    #term_menu_setup(controller_name.classify.constantize.table_name.to_sym, :Term)
    @assessment = Assessment.all    #get records user can read
    authorize! :read, @assessment
  end

  def new
    @assessment = Assessment.new
    authorize! :manage, @assessment
  end

  def create
    @assessment = Assessment.new
    @assessment.assign_attributes(assessment_params)
    authorize! :manage, @assessment
  end

  def edit
    #form_details
    @assessment = Assessment.find(params[:id])
    authorize! :manage, @assessment
  end

  def update
    @assessment = Assessment.find(params[:id])
    @assessment.update_attributes(assessment_params)
    authorize! :manage, @assessment    
    if @assessment.save
      flash[:notice] = "Updated Assessment #{@assessment.Name}."
      redirect_to(assessment_path)
    else
      form_details
      render ('edit')
  end

  def delete
  end
  
  private
  
  def assessment_params
    params.require(:assessment).permit(:name, :description)
  end
end

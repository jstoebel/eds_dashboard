# == Schema Information
#
# Table name: assessments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#

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

    # TODO: handle this logic in model
    if @assessment.save
      flash[:info] = "Created Assessment #{@assessment.name}."
      redirect_to(assessments_path)
    else
      render('new')    #renders new view
    end
  end

  def edit
    @assessment = Assessment.find(params[:id])
    authorize! :manage, @assessment
  end

  def update
    @assessment = Assessment.find(params[:id])
    authorize! :manage, @assessment  
    @assessment.update_attributes(assessment_params)
    
    # TODO: handle this logic in model
    if @assessment.save
      flash[:info] = "Updated Assessment #{@assessment.name}."
      redirect_to(assessments_path)
    else
      render ('edit')
    end
  end

  def delete
    @assessment = Assessment.find(params[:assessment_id])
    authorize! :manage, @assessment
  end
  
  def destroy
    @assessment = Assessment.find(params[:id])
    authorize! :manage, @assessment
    # TODO: handle this logic in model
    if @assessment.destroy
      flash[:info] = "Record deleted successfully"
    else
      flash[:info] = "Record cannot be deleted"
    end
    redirect_to(assessments_path)
  end
  
  private
  
  def assessment_params
    params.require(:assessment).permit(:name, :description)
  end
end

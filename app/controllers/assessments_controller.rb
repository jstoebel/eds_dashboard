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
    if @assessment.save
      flash[:notice] = "Created Assessment #{@assessment.name}."
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
    if @assessment.save
      flash[:notice] = "Updated Assessment #{@assessment.name}."
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
    if @assessment.has_scores == false
      @assessment.destroy
      flash[:notice] = "Record deleted successfully"
    else
      flash[:notice] = "Record cannot be deleted"
    end
    redirect_to(assessments_path)
  end
  
  private
  
  def assessment_params
    params.require(:assessment).permit(:name, :description)
  end
end

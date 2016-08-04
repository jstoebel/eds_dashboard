# == Schema Information
#
# Table name: assessment_versions
#
#  id            :integer          not null, primary key
#  assessment_id :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

class AssessmentVersionsController < ApplicationController
  authorize_resource
  protect_from_forgery with: :null_session
  respond_to :json
  
  def index
    #shows all versions of a particular assessment
    if params["assessment_id"]   #we only want versions of this assessment
      @assessment = Assessment.find(params[:assessment_id])
      @version = @assessment.assessment_versions.sorted.select {|r| can? :read, r }
    else
      @version = AssessmentVersion.all.sorted.select {|r| can? :read, r } 
    end
    authorize! :read, @version
    render json: @version, status: :ok
  end
  
  def show
    @version = AssessmentVersion.find(params[:id])
    authorize! :read, @version
    render json: @version, status: :ok
  end
  
  def create
    @version = AssessmentVersion.new
    authorize! :manage, @version
    @version.update_attributes(ver_params)
    if @version.save
      render json: @version, status: :created
    else
      render json: @version.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    #update the assessment the version is associated with
    @version = AssessmentVersion.find(params[:id])
    authorize! :manage, @version
    @version.update_attributes(ver_params)
    if @version.save
      render json: @version, status: :ok
    else
      render json: @version.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @version = AssessmentVersion.find(params[:id])
    authorize! :manage, @version
    if @version.has_scores == false
      @version.destroy
      render json: :nothing, status: :no_content
    else
      render json: @version.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
  def ver_params
    params.require(:assessment_version).permit(:assessment_id) 
  end
end


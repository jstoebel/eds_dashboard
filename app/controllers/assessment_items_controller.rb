# == Schema Information
#
# Table name: assessment_items
#
#  id          :integer          not null, primary key
#  slug        :string(255)
#  description :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#

class AssessmentItemsController < ApplicationController
  authorize_resource
  protect_from_forgery with: :null_session
  respond_to :json
  
  def index
    #shows all items of a particular version
    @version = AssessmentVersion.find(params[:assessment_version_id])
    authorize! :read, @version
    @item = @version.assessment_items.sorted.select {|r| can? :read, r }
    authorize! :read, @item
    render json: @item, status: :ok
  end

  def show
    @item = AssessmentItem.find(params[:id])
    authorize! :read, @item
    render json: @item, status: :ok
  end

  def create
    @item = AssessmentItem.new
    authorize! :manage, @item
    @item.update_attributes(create_params)
    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def update
    @item = AssessmentItem.find(update_params[:id])
    authorize! :manage, @item
    @item.update_attributes(update_params)
    if @item.save
      render json: @item, status: :ok
    else
      render json: @item.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def destroy
    @item = AssessmentItem.find(params[:id])
    authorize! :manage, @item
    if @item.destroy
      render json: :nothing, status: :no_content
    else
      render json: @item.errors.full_messages, status: :unprocessable_entity
    end
  end  

  private
  def create_params
    params.require(:assessment_item).permit(:slug, :description, :name)
  end
  
  def update_params
    params.require(:assessment_item).permit(:id, :slug, :description, :name)
  end
end

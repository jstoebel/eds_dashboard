# == Schema Information
#
# Table name: item_levels
#
#  id                 :integer          not null, primary key
#  assessment_item_id :integer          not null
#  descriptor         :text(65535)
#  level              :string(255)
#  ord                :integer
#  created_at         :datetime
#  updated_at         :datetime
#  cut_score          :boolean
#

class ItemLevelsController < ApplicationController
  authorize_resource
  protect_from_forgery with: :null_session
  respond_to :json
  
  def index
    #Shows all levels of an item
    @item = AssessmentItem.find(params[:assessment_item_id])
    authorize! :read, @item
    @level = @item.item_levels.sorted.select{|r| can? :read, r}
    authorize! :read, @level
    render json: @item, status: :ok
  end
  
  def show
    @level = ItemLevel.find(params[:id])
    authorize! :read, @level
    render json: @level
  end

  def create
    @level = ItemLevel.new
    authorize! :manage, @level
    @level.update_attributes(create_params)
    @item = AssessmentItem.find(create_params[:assessment_item_id])
    authorize! :manage, @item
    render json: @level, status: :ok
  end
  
  def update
    
  end

  def destroy
    @level = ItemLevel.find(params[:id])
    @item = AssessmentItem.find(params[:assessment_item_id])
    authorize! :manage, @level
    if @level.has_scores?
      render json: @level.errors.full_messages, status: :unprocessable_entity
    else 
      @level.destroy 
      render json: @item, status: :ok
    end
  end
  
  private
  
  def create_params
    params.require(:item_level).permit(:assessment_item_id, :descriptor, :level, :ord, :cut_score)
  end
  def update_params
  
  end
end

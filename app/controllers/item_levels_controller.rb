class ItemLevelsController < ApplicationController
  def update
  end

  def create
    @level = ItemLevel.new(create_params)
    @item = AssessmentItem.find(params[:assessment_item_id])
    authorize! :manage, @level
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
    params.require(:item_level).permit(:assessment_item_id, :descriptor, :level)
  end
  def update_params
  
  end
end

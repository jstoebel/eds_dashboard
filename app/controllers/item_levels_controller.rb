class ItemLevelsController < ApplicationController
  def update
  end

  def create
    @level = ItemLevel.new(create_params)
    @item = AssessmentItem.find(params[:assessment_item_id])
    authorize! :manage, @level

  end

  def delete
  end
  
  private
  
  def create_params
    params.require(:item_level).permit(:assessment_item_id, :descriptor, :level)
  end
  def update_params
  
  end
end

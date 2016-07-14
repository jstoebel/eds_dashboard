class ItemLevelsController < ApplicationController
  def update
  end

  def new
    @level = ItemLevel.new(create_params)

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

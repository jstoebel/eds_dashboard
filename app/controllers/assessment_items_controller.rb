class AssessmentItemsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json
  def index

  end

  def show

  end

  def create
    # creates an assessment_item
    # TODO: also create the associated item_levels
    
    @item = AssessmentItem.new(create_params)
    @level = ItemLevel.new(level_params), {:assessment_item_id => @item.id}

    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors.full_messages, status: :unprocessable_entity
    end
    
  end

  def update

    # update an assessment item
      # the models needs to validate that the item is not currently associated
      # with any assessments that have any scores. See Jacob for questions.
    # based on levels provided add and remove as needed
    # to edit the content of an item_level see the item_levels controller
    @item = AssessmentItem.find(params[:id])
    @levels = ItemLevel.where(:assessment_item_id => @item.id)
    if @item.scores == true
      @item.freeze    #make immutable
    else
      @item.update_attributes(update_params)
      @new_levels = @levels(update_levels)
    end
  end

  def destroy

  end

  private

  def create_params
    params.require(:assessment_item).permit(:slug, :description, :name)
  end
  
  def level_params
    params.require(:item_level).permit(:assessment_item_id, :descriptor, :level)
  end
  
  def update_levels
    params.require(:item_level).permit(:assessment_item_id, :descriptor, :level)
  end
  
  def update_params
    params.require(:assessment_item).permit(:slug, :description, :name)
  end
end
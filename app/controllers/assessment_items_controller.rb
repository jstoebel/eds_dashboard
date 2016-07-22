class AssessmentItemsController < ApplicationController
  authorize_resource
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
    @item.update_attributes(create_params)
    @level.update_attributes(level_params)
    authorize! :manage, @item
    # @level.inspect
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
    # # to edit the content of an item_level see the item_levels controller

    hashed_params = {}
    
    #puts params.inspect
    hashed_params[:slug] = params[:assessment_item][:slug]
    hashed_params[:description] = params[:assessment_item][:description]
    hashed_params[:name] = params[:assessment_item][:name]

    @item = AssessmentItem.find(params[:assessment_item][:id])
    old_levels = @item.item_levels    #active record collection. map to convert to arry
    @to_delete = old_levels.to_a
    puts @to_delete.class
    convert_levels = old_levels.map {|l| l.attributes}    #array of hashes

    if @item.has_scores?
      render json: @item.errors.full_messages, status: :unprocessable_entity
    else
      @item.assign_attributes(hashed_params)
      new_levels = []
      params[:assessment_item][:item_levels_attributes].map do |i|
        lvl_hash = {}
        lvl_hash[:descriptor] = i[:descriptor]
        lvl_hash[:level] = i[:level]
        lvl_hash[:ord] = i[:ord]
        new_levels.push(lvl_hash)
      end
      (new_levels - convert_levels).each{|l| @item.item_levels.new(l).save}
      (convert_levels - new_levels).each{|l| ItemLevel.destroy(l["id"])}
      
      if @item.save
        render json: @item, status: :ok
      else
        render json: @item.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

  def destroy

  end

  private

  def create_params
    params.require(:assessment_item).permit(:slug, :description, :name)
  end
  
  def level_params
    params.require(:assessment_item).permit(:item_levels_attributes => [:assessment_item_id, :descriptor, :level, :ord])
    #params.require(:assessment_item).permit(:item_levels => [:assessment_item_id, :descriptor, :level, :ord])
  end
  
  def update_params
    #item.permit(:id, :slug, :description, :name)
    params.require(:assessment_item).permit(:id, :slug, :description, :name, :item_levels_attributes => [:descriptor, :level, :ord])
  end
end
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
    authorize! :manage, @item
    puts @level.inspect
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
    hashed_params[:slug] = params[:assessment_item][:slug]
    hashed_params[:description] = params[:assessment_item][:description]
    hashed_params[:name] = params[:assessment_item][:name]
    puts "*"*30
    puts hashed_params.inspect

    @item = AssessmentItem.find(params[:assessment_item][:id])
    old_levels = @item.item_levels    #active record collection. map to convert to arry
    convert_levels = old_levels.map {|l| l.attributes}    #array of hashes

    if @item.has_scores?
      render json: @item.errors.full_messages, status: :unprocessable_entity
    else
      @item.update_attributes(hashed_params)
      new_levels = params[:assessment_item][:item_levels_attributes] do |i| #array of hashes
      
      (new_levels - convert_levels).each{|l| ItemLevel.create(l)}
      (convert_levels - new_levels).each{ |l| ItemLevel.find(l["id"]).destroy}
      
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
  
  def level_params(lvl)
    lvl.require(:assessment_item).permit(:item_levels_attributes => [:assessment_item_id, :descriptor, :level, :ord])
    #params.require(:assessment_item).permit(:item_levels => [:assessment_item_id, :descriptor, :level, :ord])
  end
  
  def update_params
    #item.permit(:id, :slug, :description, :name)
    params.require(:assessment_item).permit(:id, :slug, :description, :name, :item_levels_attributes => [:descriptor, :level, :ord])
  end
end
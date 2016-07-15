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
    # to edit the content of an item_level see the item_levels controller
    @item = AssessmentItem.find(params[:id])
    old_levels = @item.item_levels    #active record collection. map to convert to arry
    if @item.has_scores?
      render json: @item.errors.full_messages, status: :unprocessable_entity
    else
      @item.update_attributes(update_params)
      convert_levels = old_levels.map {|l| l.attributes}
=begin      puts "*"*50
      
      old_levels = ItemLevel.all.size
      puts "THERE ARE #{old_levels} levels"
      
      #level_params.each do |level|
      #  level.each{|l| puts l.class}

      #end
      
      #puts "NOW THERE ARE #{ItemLevel.all.size} levels"
      
      # items_array = level_params.to_a
      # items_array.each do |item|
      #   puts "LOOP!"
      #   item.each do |i|
      #     puts i
      #     puts i.class
    
      #   end
      # end

      #1/0
=end
      puts "*"*50
      #puts level_params.inspect
      puts level_params.class
      puts(level_params - convert_levels)
      (level_params - convert_levels).each{|l| puts l}#ItemLevel.create(l)}#puts l.to_h.inspect} #{ |l| ItemLevel.create(l)}
      (convert_levels - level_params).each { |l| ItemLevel.find(l["id"]).destroy }

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
    params.require(:assessment_item).permit(:item_levels => [:descriptor, :level])
  end
  
  def update_params
    params.require(:assessment_item).permit(:slug, :description, :name)
  end
end
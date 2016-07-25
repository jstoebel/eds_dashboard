class VersionHabtmItemsController < ApplicationController
  authorize_resource
  protect_from_forgery with: :null_session
  respond_to :json
  
=begin  def create
      
      @version = AssessmentVersion.new
      authorize! :manage, @version
      @version.update_attributes(ver_params)
      #add existing items to version
      
      
      @related = VersionHabtmItem.new
    
      @related.update_attributes(update_params)

      @item = AssessmentVersion.find(params)
      
  end
  
  def destroy
      #remove existing items from the version
      @item = 
  end
  
  private
  
  def item_params
  end
  
  def ver_params
      params.require(:assessment_version).permit(:)
  end
  
      
  def update_params
      params.require(:version_habtm_items).permit(:assessment_version_id, assessment_item_id)
=end
end

# == Schema Information
#
# Table name: version_habtm_items
#
#  id                    :integer          not null, primary key
#  assessment_version_id :integer          not null
#  assessment_item_id    :integer          not null
#  created_at            :datetime
#  updated_at            :datetime
#

class VersionHabtmItemsController < ApplicationController
  authorize_resource
  protect_from_forgery with: :null_session
  respond_to :json
  
  def create
    @item_ver = VersionHabtmItem.new
    authorize! :manage, @item_ver
    @item_ver.update_attributes(create_params)
    if @item_ver.save
      render json: @item_ver, status: :created
    else
      render json: @item_ver.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def destroy
    #remove existing items from the version
    @item_ver = VersionHabtmItem.find(params[:id])
    authorize! :manage, @item_ver
    if @item_ver.destroy
      render json: :nothing, status: :no_content
    else
      render json: @item_ver.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  private
  def create_params
      params.require(:version_habtm_items).permit(:assessment_version_id, :assessment_item_id)
  end
end
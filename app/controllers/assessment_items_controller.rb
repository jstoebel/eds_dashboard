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

    item = AssessmentItem.new create_params


    if item.save
      render json: item, status: :created
    else
      render json: item.errors.full_messages, status: :unprocessable_entity
    end

  end

  def update
    # update an assessment item
      # the models needs to validate that the item is not currently associated
      # with any assessments that have any scores. See Jacob for questions.
    # based on levels provided add and remove as needed
    # to edit the content of an item_level see the item_levels controller

  end

  def destroy

  end

  private

  def create_params
    params.require(:assessment_item).permit(:slug, :description, :name)
  end


end

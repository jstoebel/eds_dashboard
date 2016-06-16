module Api
  module V1
  	class BannerUpdatesController < ApplicationController
      protect_from_forgery with: :null_session
      respond_to :json
      def create
        update = BannerUpdate.new create_params
        if update.save
          render json: {:success => true, :msg => "Successfully updated banner_update"}, status: :created
        else
          render json: {:success => false, :msg => update.errors.full_messages}, status: :unprocessable_entity
        end

      end

      private 
      def create_params 
        params.require(:banner_update).permit(
          :start_term,
          :end_term
          )
      end
    end
  end
end
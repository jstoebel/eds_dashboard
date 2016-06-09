module Api
  module V1
  	class BannerUpdatesController < ApplicationController

      def create
        BannerUpdate.create params[:banner_update]
      end

    end
	end
end
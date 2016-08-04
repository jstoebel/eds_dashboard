class FoisController < ApplicationController
      
    layout 'application'
    authorize_resource
    
    def index 
        authorize! :read, @foi
        @foi = Foi.all
    end
    
    def import
        Foi.import(params[:foi_file])
        redirect_to fois_path, notice: "Products imported."
    end 
    
    
    
end
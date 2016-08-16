class FoisController < ApplicationController
      
    layout 'application'
    authorize_resource
    
    def index
        @fois = Foi.all
    end
  
    def import
        Foi.import(params[:file])
        redirect_to fois_path, notice: "Fois imported."
    end
    
    def create
       Foi.new 
    end

end
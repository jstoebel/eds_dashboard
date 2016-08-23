

class FoisController < ApplicationController
    authorize_resource
    
    def index 
        @fois = Foi.all
        authorize! :show, @foi
    end

  
    def import
        authorize! :manage, @foi
        Foi.import(params[:file])
        if @foi.imported?
            flash[:notice] = "Fois imported."
        else 
            flash[:notice] = "Could not Import File"
        end
        redirect_to fois_path
    end
    
    def create
       Foi.new 
    end
end
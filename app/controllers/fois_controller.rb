

class FoisController < ApplicationController
    authorize_resource
    
    def index 
        @fois = Foi.all
        authorize! :show, @foi
    end

  
    def import
        authorize! :manage, @fois
        Foi.import(params[:file])
        if @fois.save?
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
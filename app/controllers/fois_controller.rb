

class FoisController < ApplicationController
    authorize_resource
    
    def index 
        @fois = Foi.all
        authorize! :show, @foi
    end

  
    def import
        file = params[:file]
        Foi.import(file.path)
        # authorize! :manage, @foi
        # authorize! :manage, @student
        # Foi.new
        # #@foi = Foi.find(params[:id])
        # #@student = @foi.student
        # @foi.assign_attributes(foi_params)
        

        # #Foi.import(params[:file])
        
        # if @foi.save
        #     flash[:notice] = "Fois imported."
        # else 
        #     flash[:notice] = "Could not Import File"
        # end
        # redirect_to fois_path
    end
    
    def create
       Foi.new 
    end
    
    private
    def foi_params
        params.require(:foi).permit(:student_id, :date_completing, :new_form, :major_id, :seek_cert, :eds_only)
    end
    
end
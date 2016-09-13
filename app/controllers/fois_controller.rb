

class FoisController < ApplicationController
    authorize_resource
    
    def index 
        @fois = Foi.all
        authorize! :show, @foi
    end

  
    def import
        file = params[:file]
        result = Foi.import(file.path)
        num_rows = result[:rows]
        if result[:success]
            redirect_to fois_path, :notice => "#{num_rows} #{"form".pluralize(num_rows) + " of intention"} successfully imported."
            # went ok
        else
            redirect_to fois_path, :notice => result[:message]
            # didn't go ok
        end

    end
    
    def create
       Foi.new 
    end
    
    def show
       @fois = Foi.all
    end
    
    private
    def foi_params
        params.require(:foi).permit(:student_id, :date_completing, :new_form, :major_id, :seek_cert, :eds_only)
    end
    
end
# == Schema Information
#
# Table name: forms_of_intention
#
#  id              :integer          not null, primary key
#  student_id      :integer          not null
#  date_completing :datetime
#  new_form        :boolean
#  major_id        :integer
#  seek_cert       :boolean
#  eds_only        :boolean
#  created_at      :datetime
#  updated_at      :datetime
#



class FoisController < ApplicationController
    load_and_authorize_resource :only => [:index]
    authorize_resource :only => [:import]

    def index
      # implicetly loads all Fois user is permitted to :read
      # and assigns to @fois
    end

    def import
        file = params[:file]

        begin
          result = Foi.import(file)
        rescue => e
          redirect_to fois_path, :notice => e.message
          return
        end

        if result[:success]
          num_rows = result[:rows]
          redirect_to fois_path, :notice => "#{num_rows} #{"form".pluralize(num_rows) + " of intention"} successfully imported."
          return
            # went ok
        else
            redirect_to fois_path, :notice => "something went wrong." #result[:message]
            return
            # didn't go ok
        end

    end
    
    private
    def foi_params
        params.require(:foi).permit(:student_id, :date_completing, :new_form, :major_id, :seek_cert, :eds_only)
    end

end

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
      @fois = Foi.all.sorted
    end

    def import
        # import an foi spreadsheet
        file = params[:file]

        begin
          result = Foi.import(file)
        rescue => e
          redirect_to fois_path, :notice => e.message
          return
        end

        if result[:success]
          num_records = result[:records]
          redirect_to fois_path, :notice => "#{num_records} #{"form".pluralize(num_records) + " of intention"} successfully imported."
          return
          # went ok
        else
            redirect_to fois_path, :notice => "something went wrong."
            return
            # didn't go ok
        end

    end

    private
    # param safe listing
    def foi_params
        params
          .require(:foi) 
          .permit(
            :student_id, :date_completing, :new_form, :major_id, :seek_cert, 
            :eds_only
          )
    end

end

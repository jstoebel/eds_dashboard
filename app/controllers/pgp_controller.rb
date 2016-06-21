# == Schema Information
#
# Table Name: pgps
#
#  pgp_id :integer       not null
#  GoalName :string
#  Description :text
#  Plan :text
# 

class PgpController < ApplicationController
    authorize_resource
    
    
    def index
        @pgp = Pgps.all
        authorize! :read, @pgp
    end
    
    def edit
        @pgp = Pgps.find(params[:id])
        authorize! :read, @site
    end
    
    def create
        @pgp = Pgps.new
        @pgp.update_attributes(pgp_params)
        authorize! :manage, @pgp
        if @pgp.save
          flash[:notice] = "Created #{@pgp.GoalName}."
          redirect_to (pgp_path)
        else
          flash[:notice] = "Error creating professional growth plan."
          render 'new'
        end
    end
    
    def new
        @pgp = Pgps.new
        authorize! :manage, @pgp
    end
    
    def update
        @pgp = Pgps.find(params[:id])
        @pgp.update_attributes(pgp_params)
    end

    
    def destroy
        @pgp = Pgps.find(params[:id])    #find object and assign to instance variable
        authorize! :manage, @pgp
        if @pgp.PgpScore == nil            #if TEPAdmit does not have a value
            @pgp.destroy
            flash[:notice] = "Professional growth plan deleted successfully"
        else                               #if TEPAdmit does have a value
            flash[:notice] = "Professional growth plan cannot be deleted"    #notifies user that object cannot be deleted
        end
        redirect_to(pgp_path()) 
    end

    private
    def pgp_params
        params.require(:pgp).permit(:goal_name, :description, :plan)
    end


end

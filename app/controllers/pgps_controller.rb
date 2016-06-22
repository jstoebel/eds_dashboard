# == Schema Information
#
# Table Name: pgps
#
#  pgp_id :integer       not null
#  GoalName :string
#  Description :text
#  Plan :text
# 

class PgpsController < ApplicationController
    authorize_resource
    layout 'application'
    
    def index
        @student = Student.find(params[:student_id])
        authorize! :show, @pgp
        @pgps = @student.pgps.size
        
    end
    
    def show
        @pgp = Pgp.find(params[:id])
        authorize! :read, @pgp
        @student = Student.find(@pgp.student_id)
        name_details (@student)
    end
    
    def edit
        @pgp = Pgp.find(params[:id])
        authorize! :read, @pgp
    end
    
    def create
        @pgp = Pgp.new
        @pgp.update_attributes(pgp_params)
        authorize! :manage, @pgp
        if @pgp.save
          flash[:notice] = "Created #{@pgp.goal_name}."
          redirect_to (pgp_path)
        else
          flash[:notice] = "Error creating professional growth plan."
          render 'new'
        end
    end
    
    def new
        @pgp = Pgp.new
        authorize! :manage, @pgp
    end
    
    def update
        @pgp = Pgp.find(params[:id])
        @pgp.update_attributes(pgp_params)
    end

    
    def destroy
         @pgp = Pgp.find(params[:id])    #find object and assign to instance variable
         authorize! :manage, @pgp
         if @pgp.PgpScore == nil            #if TEPAdmit does not have a value
             @pgp.destroy
             flash[:notice] = "Professional growth plan deleted successfully"
         else                               #if TEPAdmit does have a value
             flash[:notice] = "Professional growth plan cannot be deleted"    #notifies user that object cannot be deleted
         end
         redirect_to(student_pgps_path())
    end

    private
    def pgp_params
        params.require(:pgp).permit(:goal_name, :description, :plan)
    end


end

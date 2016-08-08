# == Schema Information
#
# Table Name: pgps
#
#  pgp_id :integer       not null
#  goal_name :string
#  description :text
#  plan :text
# 

class PgpsController < ApplicationController
    layout 'application'
    authorize_resource
    
    def index
        @student = Student.find(params[:student_id])
        authorize! :show, @pgp
        @pgps = @student.pgps.sorted.select {|r| can? :read, r }
    end
    
    def show
        @pgp = Pgp.find(params[:id])
        authorize! :read, @pgp
        @student = Student.find(@pgp.student_id)
        name_details (@student)
    end
    
    def edit
        @pgp = Pgp.find(params[:id])
        authorize! :manage, @pgp
        @student = @pgp.student
        authorize! :manage, @student
    end

    def create
        @pgp = Pgp.new  
        authorize! :manage, @pgp
        @pgp.assigns_attributes(pgp_params)
        if @pgp.save
          flash[:notice] = "Created professional growth plan."
          redirect_to(student_pgps_path(@pgp.student_id))
        else
          flash[:notice] = "Error creating professional growth plan."
          @student = Student.find(params[:student_id])
          render 'new'
        end
    end
    
    def new
        @pgp = Pgp.new
        authorize! :manage, @pgp
        @student = Student.find(params[:student_id])
        
    end
    
    def update
         @pgp = Pgp.find(params[:id])
         authorize! :manage, @pgp
         @student = @pgp.student
         authorize! :manage, @student
         @pgp.assign_attributes(pgp_params)
        
         if @pgp.save
             flash[:notice] = "PGP successfully updated"
             redirect_to student_pgps_path(@pgp.student.id)
             return

         else
             flash[:notice] = "Error in editing PGP."
             error_update
             return
         end
    end

    
    def destroy
        @pgp = Pgp.find(params[:id])    
        authorize! :manage, @pgp
        @pgp.destroy
        if @pgp.destroyed?
            flash[:notice] = "Professional growth plan deleted successfully"
        else
            flash[:notice] = "Unable to alter due to scoring"
        end
        redirect_to(student_pgps_path(@pgp.student_id))
    end
    


    private
    def pgp_params
        params.require(:pgp).permit(:student_id, :goal_name, :description, :plan)
    end
    
        
    def pgp_score_params
        params.require(:pgp_score).permit(:pgp_id, :goal_score, :score_reason)
    end
    
    def error_update
        #sends user back to edit
        @student = Student.find(@pgp.student_id)
        render('edit')
    end


end

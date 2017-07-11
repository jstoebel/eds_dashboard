# == Schema Information
#
# Table name: pgps
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  goal_name   :string(255)
#  description :text(65535)
#  plan        :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#  strategies  :text(65535)
#

class PgpsController < ApplicationController
    layout 'application'
    authorize_resource

    def index
        @student = Student.find(params[:student_id])
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
        @pgp.assign_attributes(pgp_params)
        authorize! :manage, @pgp
        if @pgp.save
          flash[:info] = "Created professional growth plan."
          redirect_to(student_pgps_path(@pgp.student_id))
        else
          flash[:info] = "Error creating professional growth plan."
          @student = @pgp.student
          render 'new'
        end
    end

    def new
        @pgp = Pgp.new
        authorize! :manage, Pgp
        @student = Student.find(params[:student_id])
        authorize! :manage, Student
    end

    def update
         @pgp = Pgp.find(params[:id])
         authorize! :manage, @pgp
         @student = @pgp.student
         authorize! :manage, @student
         @pgp.assign_attributes(pgp_params)

         if @pgp.save
             flash[:info] = "PGP successfully updated"
             redirect_to student_pgps_path(@pgp.student.id)
             return

         else
             flash[:info] = "Error in editing PGP."
             error_update
             return
         end
    end


    def destroy
        # 
        @pgp = Pgp.find(params[:id])
        authorize! :manage, @pgp
        @pgp.destroy
        
        # TODO: handle this logic in model
        if @pgp.destroyed?
            flash[:info] = "Professional growth plan deleted successfully"
        else
            flash[:info] = "Unable to alter due to scoring"
        end
        redirect_to(student_pgps_path(@pgp.student_id))
    end



    private
    def pgp_params
        params
          .require(:pgp)
          .permit(:student_id, :goal_name, :description, :plan, :strategies)
    end


    def pgp_score_params
        params.require(:pgp_score).permit(:pgp_id, :goal_score, :score_reason)
    end

    def error_update
        #sends user back to edit with student pulled
        @student = Student.find(@pgp.student_id)
        render('edit')
    end


end

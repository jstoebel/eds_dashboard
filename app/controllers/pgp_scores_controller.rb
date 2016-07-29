# == Schema Information
#
# Table name: pgp_scores
#
#  id           :integer          not null, primary key
#  pgp_id       :integer
#  goal_score   :integer
#  score_reason :text(65535)
#  created_at   :datetime
#  updated_at   :datetime
#

class PgpScoresController < ApplicationController
    layout 'application'
    authorize_resource
    
    def index
        @pgp = Pgp.find(params[:pgp_id])
        authorize! :read, @pgp_score
        authorize! :read, @pgp
        @student = @pgp.student
        @pgp_scores = @pgp.pgp_scores.order(:created_at)
    end  
    
    def edit
        @pgp = Pgp.find(params[:id])
        authorize! :manage, @pgp_score
        authorize! :manage, @pgp
        @student = @pgp.student
    end

    
    def create
        @pgp_score = PgpScore.new  
        @pgp_score.update_attributes(pgp_score_params)
        authorize! :manage, @pgp_score
        authorize! :manage, @pgp
        if @pgp_score.save
          flash[:notice] = "Scored professional growth plan."
          redirect_to(pgp_pgp_scores_path())
        else
          flash[:notice] = "Error creating professional growth plan."
          @student = Student.find(params[:student_id])
          render 'new'
        end
    end
    
    def new 
        @pgp_score = PgpScore.new
        @pgp = Pgp.find(params[:pgp_id])
        authorize! :manage, @pgp_score
        authorize! :manage, @pgp
    end 
    
    def show
        @pgp_score = PgpScore.find(params[:pgp_id])
        authorize! :read, @pgp_score
        authorize! :read, @pgp
        @student = Student.find(@pgp.student_id)
        @student.name_readable
    end
    
    private
    
    def pgp_score_params
        params.require(:pgp_score).permit(:pgp_id, :goal_score, :score_reason, :score_date)
    end
end

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
        authorize! :read, @pgp
        @student = @pgp.student
        @pgp_scores = @pgp.pgp_scores.order(:created_at)
    end

    def edit
        @pgp_score = PgpScore.find(params[:id])
        @pgp = @pgp_score.pgp
        authorize! :manage, @pgp_score
        authorize! :manage, @pgp
        @student = @pgp.student
        authorize! :read, @student
    end

    def update
        @pgp_score = PgpScore.find(params[:id])
        @pgp = @pgp_score.pgp
        authorize! :manage, @pgp_score
        authorize! :manage, @pgp
        @pgp_score.assign_attributes(pgp_score_params)
        # TODO: handle this logic in model
        if @pgp_score.save
            flash[:info] = "PGP score successfully updated"
            redirect_to pgp_pgp_scores_path(@pgp_score.pgp_id)
            return
        else
            @student = @pgp.student
            flash[:info] = "Error in updating PGP score."
            render "edit"
            return
        end
    end


    def create
        @pgp_score = PgpScore.new
        authorize! :manage, @pgp_score
        @pgp_score.assign_attributes(pgp_score_params)
        # TODO: handle this logic in model
        if @pgp_score.save
          flash[:info] = "Scored professional growth plan."
          redirect_to(pgp_pgp_scores_path())
        else
          flash[:info] = "Error creating professional growth plan."
          @pgp = Pgp.find params[:pgp_id]
          @student = @pgp.student
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
        @student = Student.find(@pgp.student_id)
        authorize! :read, @student
        @student.name_readable
    end

    def destroy
        @pgp_score = PgpScore.find(params[:id])
        authorize! :manage, @pgp_score
        authorize! :manage, @pgp
        # TODO: handle this logic in model
        @pgp_score.destroy
        if @pgp_score.destroyed?
            flash[:info] = "Deleted Successfully"
        else
            flash[:info] = "Error in Deleting PGP Score"
        end
        redirect_to(pgp_pgp_scores_path(@pgp_score.pgp_id))
    end

    private

    def pgp_score_params
        params
          .require(:pgp_score)
          .permit(:pgp_id, :goal_score, :score_reason, :score_date)
    end
end

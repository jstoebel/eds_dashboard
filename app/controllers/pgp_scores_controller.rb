class PgpScoresController < ApplicationController
    layout 'application'
    authorize_resource
    
    def index
        @pgp = Pgp.find(params[:pgp_id])
        authorize! :read, @pgp_score
        authorize! :read, @pgp
        @student = @pgp.student
        @pgp_scores = @pgp.pgp_scores.order(:created_at).reverse_order
    end  
    
    def show
        @pgp = Pgp.find(params[:pgp_id])
        @pgp_score = PgpScore.find(params[:pgp_id])
        authorize! :read, @pgp_score
        authorize! :read, @pgp
        @student = Student.find(@pgp.student_id)
    end
    
    def edit
        @pgp = Pgp.find(params[:id])
        @pgp_score = PgpScore.find(params[:id])
        authorize! :manage, @pgp_score
        authorize! :manage, @pgp
        @student = Student.find(@pgp.student_id)
    end

    def update
         @pgp_score = PgpScore.find(params[:id])
         @pgp = @pgp_score.pgp
         @pgp_score.assign_attributes(pgp_score_params)
        
         if @pgp_score.save
             flash[:notice] = "PGP score successfully updated"
             redirect_to pgp_pgp_scores_path(@pgp_score.pgp_id)
             return

         else
             flash[:notice] = "Error in updating PGP score."
             error_update
             return
         end
    end
    
    def new 
        @pgp_score = PgpScore.new
        @pgp = Pgp.find(params[:pgp_id])
        authorize! :manage, @pgp_score
        authorize! :manage, @pgp
    end 

    def create
        @pgp_score = PgpScore.new  
        @pgp_score.update_attributes(pgp_score_params)
        authorize! :manage, @pgp_score
        authorize! :manage, @pgp
        if @pgp_score.save
          flash[:notice] = "Scored professional growth plan."
          redirect_to(pgp_pgp_scores_path(@pgp_score.pgp_id))
        else
          flash[:notice] = "Error scoring professional growth plan."
          @student = Student.find(params[:student_id])
          render 'new'
        end
    end
    
    def destroy
        @pgp_score = PgpScore.find(params[:id])
        authorize! :manage, @pgp_score
        authorize! :manage, @pgp
        # added after test --> check w/JS #read,write, and manage
        @pgp_score.destroy
        if @pgp_score.destroyed?
            flash[:notice] = "Deleted Successfully"
        else
            flash[:notice] = "Error in Deleting PGP Score"
        end
        redirect_to(pgp_pgp_scores_path(@pgp_score.pgp_id))
    end

    private
    
    def pgp_score_params
        params.require(:pgp_score).permit(:pgp_id, :goal_score, :score_reason, :score_date)
    end
end
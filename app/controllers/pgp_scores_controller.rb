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
        @pgp_score = PgpScore.find(params[:pgp_id])
        authorize! :read, @pgp_score
        authorize! :read, @pgp
        @student = Student.find(@pgp.student_id)
        @student.name_readable
    end
    
    def edit
        @pgp = Pgp.find(params[:id])
        authorize! :manage, @pgp_score
        authorize! :manage, @pgp
        @student = @pgp.student
    end

# TODO Update  correct? needs testing
    def update
         @student = Student.find(params[:id])
         @pgp_score = PgpScore.find(params[:id])
         @pgp.assign_attributes(pgp_params)
        
         if @pgp_score.save
             flash[:notice] = "PGP score successfully updated"
             redirect_to pgp_score_path(@pgp.student.id)
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
          redirect_to(pgp_pgp_scores_path())
        else
          flash[:notice] = "Error creating professional growth plan."
          @student = Student.find(params[:student_id])
          render 'new'
        end
    end
    
# TODO Destory   correct? needs testing
    def destroy
        @pgp_score = PgpScore.find(params[:id])
        authorize! :manage, @pgp_score # added after test --> check w/JS #read,write, and manage
        @pgp_score.visible = false
        @pgp_score.save
        flash[:notice] = "Deleted Successfully!"
        redirect_to(pgp_pgp_scores_path(@pgp_score.student.id))
    end

    private
    
    def pgp_score_params
        params.require(:pgp_score).permit(:pgp_id, :goal_score, :score_reason, :score_date)
    end
end
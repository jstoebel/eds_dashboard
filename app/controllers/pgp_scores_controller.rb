class PgpScoresController < ApplicationController
    layout 'application'
    authorize_resource
    
    def index
        @pgp = Pgp.find(params[:pgp_id])
        authorize! :read, @pgp_score
        @student = Student.find(@pgp.student.id)
        @pgp_scores = @student.pgp.pgp_scores.sorted.select {|r| can? :read, r }
    end  
    
    def edit
        @pgp = Pgp.find(params[:id])
        authorize! :manage, @pgp_score
        @student = Student.find(params[:id])
    end

    
    def create
        @pgp_score = PgpScore.new  
        @pgp_score.update_attributes(pgp_score_params)
        authorize! :manage, @pgp_score
        if @pgp_score.save
          flash[:notice] = "Scored professional growth plan."
          redirect_to(action: "index")
        else
          flash[:notice] = "Error creating professional growth plan."
          @student = Student.find(params[:student_id])
          render 'new'
        end
    end
    
    def new 
        @pgp_score = PgpScore.new
       # @student = Student.find(params[:student_id])
        @pgp = Pgp.find(params[:pgp_id])
        authorize! :manage, @pgp_score
    end 
    
    # def update
    #     @pgp_score = PgpScore.find(params[:id])
    #     authorize! :manage, @pgp_score
    #     @pgp_score.assign_attributes(pgp_score_params)
        
    #     if @pgp_score.save
    #         flash[:notice] = "PGP score successfully updated"
    #         redirect_to student_pgps_path(@pgp.id)
    #         return

    #     else
    #         flash[:notice] = "Error in scoring PGP."
    #         error_update
    #         return
    #     end    
    # end
    
    def show
        @pgp_score = PgpScore.find(params[:pgp_id])
        authorize! :read, @pgp_score
        @student = Student.find(@pgp.student_id)
        name_details (@student)
    end
    
    private
    
    def pgp_score_params
        params.require(:pgp_score).permit(:pgp_id, :goal_score, :score_reason)
    end
end
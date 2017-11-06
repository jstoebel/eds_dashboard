##
# controller for pgp_goals
class PgpGoalsController < ApplicationController
  before_action :set_pgp_goal, only: %i[show edit update destroy]
  before_action :set_student, only: %i[index new]

  def index
    @pgp_goals = @student.pgp_goals.order(:active).reverse_order
  end

  # GET /pgp_goals/new
  def new
    @pgp_goal = PgpGoal.new student_id: @student.id
  end

  # POST /pgp_goals
  def create
    @pgp_goal = PgpGoal.new(pgp_goal_params)
    if @pgp_goal.save
      flash[:info] = 'Pgp goal was successfully created.'
      redirect_to student_pgp_goals_path(@pgp_goal.student.id)
    else
      @student = Student.find params[:pgp_goal][:student_id]
      render :new
    end
  end

  # GET /pgp_goals/1/edit
  def edit
    @student = @pgp_goal.student
  end

  # PATCH/PUT /pgp_goals/1
  def update
    if @pgp_goal.update(pgp_goal_params)
      flash[:info] = 'Pgp goal was successfully updated.'
      redirect_to student_pgp_goals_path(@pgp_goal.student.id)
    else
      @student = Student.find params[:pgp_goal][:student_id]
      render :edit
    end
  end

  def destroy
    @pgp_goal.destroy!
    flash[:info] = "Goal removed" 
    redirect_to student_pgp_goals_url @pgp_goal.student.id
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pgp_goal
    @pgp_goal = PgpGoal.find(params[:id])
  end

  def set_student
    @student = Student.find(params[:student_id])
  end

  # Never trust parameters from the scary internet,
  # only allow these attrs through.
  def pgp_goal_params
    params.require(:pgp_goal).permit(:name, :domain, :active, :student_id)
  end
end

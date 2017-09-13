class PgpGoalsController < ApplicationController
  before_action :set_pgp_goal, only: [:show, :edit, :update, :toggle_active]
  before_action :set_student, only: [:index, :new]

  def index
    @pgp_goals = @student.pgp_goals.order(:active).reverse_order
  end

  # GET /pgp_goals/new
  def new
    @pgp_goal = PgpGoal.new student_id: @student.id
  end

  # GET /pgp_goals/1/edit
  def edit
    @student = @pgp_goal.student
  end

  # POST /pgp_goals
  # POST /pgp_goals.json
  def create
    @pgp_goal = PgpGoal.new(pgp_goal_params)
    respond_to do |format|
      if @pgp_goal.save
        flash[:info] = 'Pgp goal was successfully created.'
        format.html { redirect_to student_pgp_goals_path(@pgp_goal.student.id)}
        format.json { render :show, status: :created, location: @pgp_goal }
      else
        @student = Student.find params[:pgp_goal]{:student_id}
        format.html { render :new }
        format.json { render json: @pgp_goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pgp_goals/1
  # PATCH/PUT /pgp_goals/1.json
  def update
    respond_to do |format|
      if @pgp_goal.update(pgp_goal_params)
        flash[:info] = 'Pgp goal was successfully updated.'
        format.html { redirect_to student_pgp_goals_path(@pgp_goal.student.id)}
        format.json { render :show, status: :ok, location: @pgp_goal }
      else
        format.html { render :edit }
        format.json { render json: @pgp_goal.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pgp_goal
      @pgp_goal = PgpGoal.find(params[:id])
    end

    def set_student
      @student = Student.find(params[:student_id])
    end

    # Never trust parameters from the scary internet, only allow these attrs through.
    def pgp_goal_params
      params.require(:pgp_goal).permit(:name, :domain, :active, :student_id)
    end
end

class PgpGoalsController < ApplicationController
  before_action :set_pgp_goal, only: [:show, :edit, :update, :destroy]

  # GET /pgp_goals
  # GET /pgp_goals.json
  def index
    @pgp_goals = PgpGoal.all
  end

  # GET /pgp_goals/1
  # GET /pgp_goals/1.json
  def show
  end

  # GET /pgp_goals/new
  def new
    @pgp_goal = PgpGoal.new
  end

  # GET /pgp_goals/1/edit
  def edit
  end

  # POST /pgp_goals
  # POST /pgp_goals.json
  def create
    @pgp_goal = PgpGoal.new(pgp_goal_params)

    respond_to do |format|
      if @pgp_goal.save
        format.html { redirect_to @pgp_goal, notice: 'Pgp goal was successfully created.' }
        format.json { render :show, status: :created, location: @pgp_goal }
      else
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
        format.html { redirect_to @pgp_goal, notice: 'Pgp goal was successfully updated.' }
        format.json { render :show, status: :ok, location: @pgp_goal }
      else
        format.html { render :edit }
        format.json { render json: @pgp_goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pgp_goals/1
  # DELETE /pgp_goals/1.json
  def destroy
    @pgp_goal.destroy
    respond_to do |format|
      format.html { redirect_to pgp_goals_url, notice: 'Pgp goal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pgp_goal
      @pgp_goal = PgpGoal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow these attrs through.
    def pgp_goal_params
      params.require(:pgp_goal).permit(:name, :domain, :active)
    end
end

##
# pgp_strategies controller

class PgpStrategiesController < ApplicationController
  before_action :set_pgp_strategy, only: %i[show edit update]
  before_action :set_pgp_goal, only: %i[index new]

  def index
    @pgp_strategies = @pgp_goal.pgp_strategies.order(:active).reverse_order
  end

  def new
    @pgp_strategy = PgpStrategy.new pgp_goal_id: @pgp_goal.id
  end

  def create
    @pgp_strategy = PgpStrategy.new(pgp_strategy_params)
    if @pgp_strategy.save
      flash[:info] = 'Pgp strategy was successfully created.'
      redirect_to pgp_goal_pgp_strategies_path(@pgp_strategy.pgp_goal.id)
    else
      @pgp_goal = PgpGoal.find params[:pgp_goal_id]
      render :new
    end
  end

  def edit
    @pgp_goal = @pgp_strategy.pgp_goal
  end

  def update
    if @pgp_strategy.update(pgp_strategy_params)
      flash[:info] = 'Pgp strategy was successfully updated.'
      redirect_to pgp_goal_pgp_strategies_path(@pgp_strategy.pgp_goal.id)
    else
      @pgp_goal = PgpGoal.find params[:pgp_strategy][:pgp_goal_id]
      render :edit
    end
  end

  private

  def set_pgp_strategy
    @pgp_strategy = PgpStrategy.find(params[:id])
  end

  def set_pgp_goal
    @pgp_goal = PgpGoal.find(params[:pgp_goal_id])
  end

  ##
  # Never trust parameters from the scary internet,
  # only allow these attrs through.
  def pgp_strategy_params
    params
      .require(:pgp_strategy)
      .permit(:pgp_goal_id, :name, :timeline, :resources, :active)
  end
end

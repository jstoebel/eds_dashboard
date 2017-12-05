class PgpScoresController < ApplicationController
  before_action :set_pgp_score, only: %i[show edit update destroy]
  before_action :set_pgp_goal, only: %i[index]
  
  ##
  # fetch all pgp_scores associated with the given pgp_goal
  # grouped by scored_at
  def index
    scored_timestamps = @pgp_goal.pgp_scores.pluck(:scored_at).uniq
    @score_groups = scored_timestamps.map do |ts|
      PgpScore.where(pgp_goal_id: @pgp_goal.id, scored_at: ts)
    end
  end

  # GET /pgp_scores/1
  # GET /pgp_scores/1.json
  def show
  end

  # GET /pgp_scores/new
  def new
    @pgp_score = PgpScore.new
  end

  # GET /pgp_scores/1/edit
  def edit
  end

  # POST /pgp_scores
  # POST /pgp_scores.json
  def create
    @pgp_score = PgpScore.new(pgp_score_params)

    respond_to do |format|
      if @pgp_score.save
        format.html { redirect_to @pgp_score, notice: 'Pgp score was successfully created.' }
        format.json { render :show, status: :created, location: @pgp_score }
      else
        format.html { render :new }
        format.json { render json: @pgp_score.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pgp_scores/1
  # PATCH/PUT /pgp_scores/1.json
  def update
    respond_to do |format|
      if @pgp_score.update(pgp_score_params)
        format.html { redirect_to @pgp_score, notice: 'Pgp score was successfully updated.' }
        format.json { render :show, status: :ok, location: @pgp_score }
      else
        format.html { render :edit }
        format.json { render json: @pgp_score.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pgp_scores/1
  # DELETE /pgp_scores/1.json
  def destroy
    @pgp_score.destroy
    respond_to do |format|
      format.html { redirect_to pgp_scores_url, notice: 'Pgp score was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pgp_goal
      @pgp_goal = PgpGoal.find(params[:pgp_goal_id])
    end

    def set_pgp_score
      @pgp_score = PgpScore.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pgp_score_params
      params.fetch(:pgp_score, {})
    end
end

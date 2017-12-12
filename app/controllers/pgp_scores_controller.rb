class PgpScoresController < ApplicationController
  before_action :set_pgp_score, only: %i[edit update]
  before_action :set_pgp_goal, only: %i[index new create destroy]
  before_action :form_setup, only: %i[new]
  before_action :authorize_goal

  ##
  # fetch all pgp_scores associated with the given pgp_goal
  # grouped by scored_at
  def index
    scored_timestamps = @pgp_goal.pgp_scores.pluck(:scored_at).uniq
    @score_groups = scored_timestamps.map do |ts|
      PgpScore.where(pgp_goal_id: @pgp_goal.id, scored_at: ts)
    end
  end

  def new; end

  # expected params
  # :pgp_goal_id
  # :item_levels => {assessment_item_id_:id => :item_level_id}
  # use this mapping to determine the level for each item

  def create
    PgpScore.transaction do
      PgpScore.create! pgp_score_params
    end # transaction

    flash[:info] = "Scores recieved for #{@pgp_goal.name}"
    redirect_to pgp_goal_pgp_scores_path(@pgp_goal)
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    flash[:info] = 'There was a problem recording your scores. Please try again.' \
                   'If the problem persists, please contact your administrator.'

    form_setup
    render 'new'
  end

  ##
  # destroy all pgp_scores scored on the given date
  def destroy
    ts_utc = DateTime.strptime(params[:timestamp], '%Y-%m-%d %H:%M:%S %z').utc
    PgpScore.transaction do
      @pgp_goal.pgp_scores.where(scored_at: ts_utc).destroy_all
    end

    # happy path
    flash[:info] = "Deleted all PGP scores for #{@pgp_goal.name} on #{ts_utc.strftime('%m/%d/%Y')}"
  rescue ActiveRecord::RecordNotDestroyed => e
    flash[:info] = 'There was a problem recording your scores. Please try again.' \
                   'If the problem persists, please contact your administrator.'
  ensure
    redirect_to pgp_goal_pgp_scores_path(@pgp_goal)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pgp_goal
    @pgp_goal = PgpGoal.find params[:pgp_goal_id]
  end

  def set_pgp_score
    @pgp_score = PgpScore.find(params[:id])
  end

  def form_setup
    @assessment_items = Assessment.find_by_name('PGP 1').andand.assessment_items
  end

  ##
  # returns array of hashes each representing a single pgp_score
  def pgp_score_params
    scored_time_stamp = DateTime.now.utc
    item_levels = []
    params[:item_levels].each do |_, val|
      level = ItemLevel.find val
      item_levels << { item_level_id: level.id,
        pgp_goal_id: @pgp_goal.id,
        student_id: @pgp_goal.student.id,
        scored_at: scored_time_stamp }
    end # map
    item_levels
  end # pgp_score_params

  def authorize_goal
    authorize! :manage, @pgp_goal
  end
end

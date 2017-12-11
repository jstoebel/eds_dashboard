require 'test_helper'

class PgpScoresControllerTest < ActionDispatch::IntegrationTest

  before do
    @pgp_goal = FactoryGirl.create :pgp_goal
  end

  describe 'INDEX' do

    before do

      @earlier_scores = FactoryGirl.create_list :pgp_score, 5,
                                                scored_at: 45.days.ago,
                                                pgp_goal: @pgp_goal

      @todays_scores = FactoryGirl.create_list :pgp_score, 5,
                                               scored_at: Date.today,
                                               pgp_goal: @pgp_goal

      get pgp_goal_pgp_scores_path(@pgp_goal.id)
    end # before

    it 'pulls @pgp_goal' do
      assert_equal @pgp_goal, assigns(:pgp_goal)
    end

    it 'pulls @score_groups' do
      assert_equal [@earlier_scores, @todays_scores], assigns(:score_groups)
    end

    it 'renders 200 ok' do
      assert_response :success
    end

    it 'renders index template' do
      assert_template :index
    end

  end # INDEX

  describe 'NEW' do

    before do
      @assessment = FactoryGirl.create :assessment_with_scores, name: 'PGP 1'
      get new_pgp_goal_pgp_score_path(@pgp_goal.id)
    end

    it 'pulls @pgp_goal' do
      assert @pgp_goal, assigns(:pgp_goal)
    end

    it 'pulls @assessment_items' do
      assert @assessment.assessment_items.to_a, assigns(:assessment_items).to_a
    end

    it 'renders 200 ok' do
      assert_response :success
    end

    it 'renders index template' do
      assert_template :new
    end

  end #'NEW'

  describe 'create' do

  end

  # setup do
  #   @pgp_score = pgp_scores(:one)
  # end

  # test "should get index" do
  #   get pgp_scores_url
  #   assert_response :success
  # end

  # test "should get new" do
  #   get new_pgp_score_url
  #   assert_response :success
  # end

  # test "should create pgp_score" do
  #   assert_difference('PgpScore.count') do
  #     post pgp_scores_url, params: { pgp_score: {  } }
  #   end

  #   assert_redirected_to pgp_score_url(PgpScore.last)
  # end

  # test "should show pgp_score" do
  #   get pgp_score_url(@pgp_score)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_pgp_score_url(@pgp_score)
  #   assert_response :success
  # end

  # test "should update pgp_score" do
  #   patch pgp_score_url(@pgp_score), params: { pgp_score: {  } }
  #   assert_redirected_to pgp_score_url(@pgp_score)
  # end

  # test "should destroy pgp_score" do
  #   assert_difference('PgpScore.count', -1) do
  #     delete pgp_score_url(@pgp_score)
  #   end

  #   assert_redirected_to pgp_scores_url
  # end
end

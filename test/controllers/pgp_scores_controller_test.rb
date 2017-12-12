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

  describe 'CREATE' do
    let(:post_request) do
      post pgp_goal_pgp_scores_path(@pgp_goal.id), params: @req_body
    end
    describe 'happy path' do
      before do

        # create five item_levels belonging to the same assessment
        assessment = FactoryGirl.create :assessment

        @item_levels = Array.new(2).map do |_|
          assessment_item = FactoryGirl.create :assessment_item,
                                               assessment: assessment
          level = FactoryGirl.create :item_level,
                                     assessment_item: assessment_item

          ["assessment_item_id_#{assessment_item.id}", level.id]
        end.to_h

        @req_body = { pgp_goal_id: @pgp_goal.id, item_levels: @item_levels }
      end

      it 'creates pgp_scores' do
        assert_difference -> { PgpScore.count }, @item_levels.size do
          post_request
        end
      end

      it 'creates flash message' do
        post_request
        assert_equal flash[:info], "Scores recieved for #{@pgp_goal.name}"
      end

      it 'redirects' do
        post_request
        assert_redirected_to pgp_goal_pgp_scores_path(@pgp_goal.id)
      end
    end

    describe 'sad path' do
      before do
        @bad_item_levels = {badassessment_item_1: 1, badassessment_item_2: 2}
        @req_body = { pgp_goal_id: @pgp_goal.id, item_levels: @bad_item_levels }

        # required to render new template
        @assessment = FactoryGirl.create :assessment_with_scores, name: 'PGP 1'

      end

      it 'creates flash message' do
        # try to reference item_levels that don't exist
        post_request
      end

      it 'creates no pgp_scores' do
        assert_difference -> { PgpScore.count }, 0 do
          post_request
        end
      end

      it 'pulls @assessment_items' do
        post_request
        assert @assessment.assessment_items.to_a,
               assigns(:assessment_items).to_a
      end

      it 'renders new template' do
        post_request
        assert_template :new
      end

    end

  end # CREATE


  describe 'DESTROY' do
    before do
       @pgp_scores = FactoryGirl.create_list :pgp_score, 2,
                                             pgp_goal: @pgp_goal,
                                             scored_at: DateTime.now
    end

    let(:delete_destroy) do
      ts = @pgp_scores.first.scored_at.strftime('%Y-%m-%d %H:%M:%S %z')
      delete pgp_goal_delete_scores_path @pgp_goal.id, params: {timestamp: ts }
    end

    describe 'happy path' do

      it 'destroys all records' do
        assert_difference -> { PgpScore.count }, -@pgp_scores.size do
          delete_destroy
        end
      end

      it 'stores flash message' do
        # finish me!
      end

      it 'redirects' do
        delete_destroy
        assert_redirected_to pgp_goal_pgp_scores_path(@pgp_goal)
      end

    end # 'happy path'

    describe 'sad path' do

      before do
        # lets pretend that records can't be destroyed
        PgpScore.any_instance.stubs(:destroy).raises(ActiveRecord::RecordNotDestroyed)
      end

      it 'doesn\'t destroy records' do
        assert_difference -> { PgpScore.count }, 0 do
          delete_destroy
        end
      end

      it 'stores flash message' do
        # finish me!
      end

      it 'redirects' do
        delete_destroy
        assert_redirected_to pgp_goal_pgp_scores_path(@pgp_goal)
      end


    end

  end # DESTROY

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

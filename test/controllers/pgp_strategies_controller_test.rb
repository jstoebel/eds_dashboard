require 'test_helper'

class PgpStrategiesControllerTest < ActionDispatch::IntegrationTest

  before do
    @pgp_goal = FactoryGirl.create :pgp_goal
    @strategies = FactoryGirl.create_list :pgp_strategy, 2, pgp_goal: @pgp_goal 
  end

  describe 'INDEX' do
    let(:get_index) do
      get pgp_goal_pgp_strategies_path @pgp_goal.id
    end
        
    it 'pulls @pgp_strategies' do

      # deactivate a strategy
      @strategies.first.update_attributes! active: false
      get_index
      assert_equal @strategies.size,
                   assigns(:pgp_strategies).size
    end

    it 'returns 200 ok' do
      get_index
      assert_response :success
    end

    it 'renders index template' do
      get_index
      assert_template :index
    end

  end

  describe 'NEW' do
    before do
      get new_pgp_goal_pgp_strategy_path @pgp_goal
    end

    it 'pulls fresh @pgp_strategy' do
      assert assigns(:pgp_strategy).new_record?
    end

    it 'returns 200 ok' do
      assert_response :success
    end

    it 'renders new template' do
      assert_template :new
    end

  end

  describe 'CREATE' do

    before do
      @strategy = FactoryGirl.build :pgp_strategy, pgp_goal: @pgp_goal
    end

    let(:post_create) do

      desired_attrs = ['name', 'timeline', 'resources', 'active', 'pgp_goal_id']
      post pgp_strategies_path,
           params: { pgp_goal_id: @pgp_goal.id,
                     pgp_strategy: @strategy.attributes.slice(*desired_attrs) 
                   }
    end

    let(:stub_save) {PgpStrategy.any_instance.stubs(:save).returns(false)}

    describe 'happy path' do

      it 'creates a @pgp_strategy' do
        assert_difference -> { PgpStrategy.count }, 1 do
          post_create
        end
      end

      it 'redirects' do
        post_create
        assert_redirected_to pgp_goal_pgp_strategies_path(@pgp_goal.id)
      end
    end

    describe 'sad path' do
      before do
        stub_save
      end
      it 'creates a @pgp_strategy' do
        assert_difference -> { PgpStrategy.count }, 0 do
          post_create
        end
      end

      it 'renders new' do
        post_create
        assert_template :new
      end

    end

  end # CREATE

  describe 'EDIT' do
    before do
      @pgp_strategy = FactoryGirl.create :pgp_strategy, pgp_goal: @pgp_goal
      get edit_pgp_goal_pgp_strategy_path(@pgp_goal.id, @pgp_strategy.id)
    end

    it 'pulls @pgp_score' do
      assert_equal @pgp_strategy, assigns(:pgp_strategy)
    end

    it 'pulls pgp_goal' do
      assert_equal @pgp_goal, assigns(:pgp_goal)
    end

    it 'returns 200 ok' do
      assert_response :success
    end

    it 'renders edit template' do
      assert_template :edit
    end
  end

  describe 'UPDATE' do

    before do
      @strategy = FactoryGirl.create :pgp_strategy, pgp_goal: @pgp_goal
    end

    let(:patch_update) do
      @new_params = @strategy.attributes.merge('name' => 'new name')
      patch pgp_goal_pgp_strategy_path(@pgp_goal.id, @strategy.id),
            params: { pgp_goal_id: @pgp_goal.id, id: @strategy.id, pgp_strategy: @new_params}
    end

    let(:stub_save) {PgpStrategy.any_instance.stubs(:update).returns(false)}

    describe 'happy path' do

      it 'updates params' do
        patch_update
        @new_params.each do |key, val|
          assert_equal val, assigns(:pgp_strategy).send(key)
        end
      end

      it 'redirects' do
        patch_update
        assert_redirected_to pgp_goal_pgp_strategies_path(@pgp_goal.id)
      end

      it 'returns http 302' do
        patch_update
        assert_response 302
      end
    end

    describe 'sad path' do
      before do
        stub_save
        patch_update
      end

      it 'pulls @pgp_goal' do
        assert_equal @pgp_goal, assigns(:pgp_goal)
      end

      it 'renders edit template' do
        assert_template :edit
      end

    end
  end # CREATE

end

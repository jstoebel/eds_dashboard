require 'test_helper'

##
# tests for pgp_goal controller
class PgpGoalsControllerTest < ActionDispatch::IntegrationTest
  describe 'index' do
    setup do
      @stu = FactoryGirl.create :student

      # make three active and one not active goals
      FactoryGirl.create :pgp_goal, student: @stu, active: false
      FactoryGirl.create_list :pgp_goal, 3, student: @stu, active: true

      # make a goal belonging to another student
      FactoryGirl.create :pgp_goal
      @expected_pgp_goals = @stu.pgp_goals.order(:active).reverse_order

      get student_pgp_goals_url(@stu.id)
    end

    test 'should get index' do
      assert_response :success
    end

    test 'should set instance variables' do
      assert_equal @expected_pgp_goals.to_a, assigns(:pgp_goals)
      assert_equal @stu, assigns(:student)
    end
  end

  describe 'show' do
    setup do
      @pgp_goal = FactoryGirl.create :pgp_goal
      @student = @pgp_goal.student
    end

    test 'should get show' do
      assert_response :success
    end

    test 'should set instance variables' do
      assert_equal @pgp_goal, assigns(:pgp_goal)
      assert_equal @student, assigns(:student)
    end
  end

  describe 'new' do
    setup do
      @stu = FactoryGirl.create :student
      get new_student_pgp_goal_url @stu.id
    end

    test 'should get new' do
      assert_response :success
    end

    test 'should set instance variables' do
      new_pgp = PgpGoal.new student_id: @stu.id
      assert_equal new_pgp.attributes, assigns(:pgp_goal).attributes
      assert_equal @stu, assigns(:student)
    end
  end

  describe 'edit' do
    setup do
      @pgp_goal = FactoryGirl.create :pgp_goal
      get edit_pgp_goal_url @pgp_goal.id
    end

    test 'should get edit' do
      assert_response :success
    end

    test 'should set instance variables' do
      assert_equal @pgp_goal, assigns(:pgp_goal)
      assert_equal @pgp_goal.student, assigns(:student)
    end
  end

  describe 'create' do
    setup do
      @student = FactoryGirl.create :student
    end

    describe 'valid' do
      setup do
        @pgp_attrs = FactoryGirl.attributes_for :pgp_goal
        @pgp_attrs[:student_id] = @student.id
        post pgp_goals_url, params: { pgp_goal: @pgp_attrs }
      end

      test 'should create the record' do
        expected_goal = @student.pgp_goals.first.attributes
        expected_attrs = expected_goal
                         .except('id', 'stundet_id', 'created_at', 'updated_at')
                         .map { |k, v| [k.to_sym, v] }
                         .to_h
        assert_equal expected_attrs, @pgp_attrs
      end

      test 'should set flash message' do
        assert_equal flash[:info], 'Pgp goal was successfully created.'
      end

      test 'should redirect' do
        assert_redirected_to student_pgp_goals_path(@student.id)
      end
    end # invalid

    describe 'invalid' do
      setup do
        @pgp_attrs = FactoryGirl.attributes_for :pgp_goal, name: nil
        @pgp_attrs[:student_id] = @student.id
        post pgp_goals_url, params: { pgp_goal: @pgp_attrs }
      end

      test 'returns 200 OK' do
        assert_response :success
      end

      test 'pulls student' do
        assert_equal @student, assigns(:student)
      end

      test 'renders new' do
        assert_template :new
      end
    end # invalid
  end # create

  describe 'update' do
    setup do
      @pgp_goal = FactoryGirl.create :pgp_goal
      @student = @pgp_goal.student
    end

    describe 'valid' do
      setup do
        @pgp_attrs = @pgp_goal.attributes
                              .merge 'name' => 'new name'
        patch pgp_goal_url @pgp_goal.id, params: { pgp_goal: @pgp_attrs }
      end

      test 'should update the record' do
        actual_attrs = PgpGoal.find(@pgp_goal.id).attributes
        assert_equal @pgp_attrs.except('updated_at'),
                     actual_attrs.except('updated_at')
      end

      test 'should set flash message' do
        assert_equal flash[:info], 'Pgp goal was successfully updated.'
      end

      test 'should redirect' do
        assert_redirected_to student_pgp_goals_path(@pgp_goal.student.id)
      end
    end # invalid

    describe 'invalid' do
      setup do
        @pgp_attrs = @pgp_goal.attributes
                              .merge 'name' => nil
        patch pgp_goal_url @pgp_goal.id, params: { pgp_goal: @pgp_attrs }
      end

      test 'returns 200 OK' do
        assert_response :success
      end

      test 'pulls student' do
        assert_equal @student, assigns(:student)
      end

      test 'renders edit' do
        assert_template :edit
      end
    end # invalid
  end # create

  describe 'destroy' do
    before do
      @pgp_goal = FactoryGirl.create :pgp_goal
      delete "/pgp_goals/#{@pgp_goal.id}"
    end
    test 'is not persisted' do
      assert_raise(ActiveRecord::RecordNotFound) { PgpGoal.find @pgp_goal.id}
    end

    test 'sets flash message' do
      assert_equal flash[:info], "Goal removed"
    end

    test 'redirects' do
      assert_redirected_to student_pgp_goals_url @pgp_goal.student.id
    end
  end
end

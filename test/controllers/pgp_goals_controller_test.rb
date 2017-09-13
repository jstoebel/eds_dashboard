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

    # should get goals
    test 'should set instance variables' do
      assert_equal @expected_pgp_goals.to_a, assigns(:pgp_goals)
    end

    test 'should set instance variables' do
      assert_equal @expected_pgp_goals.to_a, assigns(:pgp_goals)
      assert_equal @stu, assigns(:student)
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
        @student = FactoryGirl.create :student
        @pgp_attrs = FactoryGirl.attributes_for :pgp_goal
        @pgp_attrs.merge! student_id: @student.id
        post pgp_goals_url, params: {pgp_goal: @pgp_attrs}
      end

      test 'should create the record' do
        expected_goal = @student.pgp_goals.first.attributes
        expected_attrs = expected_goal
                         .except("id", "stundet_id", "created_at", "updated_at")
                         .map{|k,v| [k.to_sym, v] }
                         .to_h
        assert_equal expected_attrs, @pgp_attrs
      end

      test 'should set flash message' do
        assert_equal flash[:info], 'Pgp goal was successfully created.'
      end

      test 'should redirect' do
        assert_redirected_to student_pgp_goals_path(@student.id)

      end

    end

    describe 'invalid' do
    end
  end

  # test "should get new" do
  #   get new_pgp_goal_url
  #   assert_response :success
  # end

  # test "should create pgp_goal" do
  #   assert_difference('PgpGoal.count') do
  #     post pgp_goals_url, params: { pgp_goal: { active: @pgp_goal.active, domain: @pgp_goal.domain, name: @pgp_goal.name } }
  #   end

  #   assert_redirected_to pgp_goal_url(PgpGoal.last)
  # end

  # test "should show pgp_goal" do
  #   get pgp_goal_url(@pgp_goal)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_pgp_goal_url(@pgp_goal)
  #   assert_response :success
  # end

  # test "should update pgp_goal" do
  #   patch pgp_goal_url(@pgp_goal), params: { pgp_goal: { active: @pgp_goal.active, domain: @pgp_goal.domain, name: @pgp_goal.name } }
  #   assert_redirected_to pgp_goal_url(@pgp_goal)
  # end

  # test "should destroy pgp_goal" do
  #   assert_difference('PgpGoal.count', -1) do
  #     delete pgp_goal_url(@pgp_goal)
  #   end

  #   assert_redirected_to pgp_goals_url
  # end
end

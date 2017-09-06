require 'test_helper'

class PgpGoalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pgp_goal = pgp_goals(:one)
  end

  test "should get index" do
    get pgp_goals_url
    assert_response :success
  end

  test "should get new" do
    get new_pgp_goal_url
    assert_response :success
  end

  test "should create pgp_goal" do
    assert_difference('PgpGoal.count') do
      post pgp_goals_url, params: { pgp_goal: { active: @pgp_goal.active, domain: @pgp_goal.domain, name: @pgp_goal.name } }
    end

    assert_redirected_to pgp_goal_url(PgpGoal.last)
  end

  test "should show pgp_goal" do
    get pgp_goal_url(@pgp_goal)
    assert_response :success
  end

  test "should get edit" do
    get edit_pgp_goal_url(@pgp_goal)
    assert_response :success
  end

  test "should update pgp_goal" do
    patch pgp_goal_url(@pgp_goal), params: { pgp_goal: { active: @pgp_goal.active, domain: @pgp_goal.domain, name: @pgp_goal.name } }
    assert_redirected_to pgp_goal_url(@pgp_goal)
  end

  test "should destroy pgp_goal" do
    assert_difference('PgpGoal.count', -1) do
      delete pgp_goal_url(@pgp_goal)
    end

    assert_redirected_to pgp_goals_url
  end
end

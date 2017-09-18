require 'test_helper'

class PgpStrategiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pgp_strategies_index_url
    assert_response :success
  end

  test "should get new" do
    get pgp_strategies_new_url
    assert_response :success
  end

  test "should get create" do
    get pgp_strategies_create_url
    assert_response :success
  end

  test "should get edit" do
    get pgp_strategies_edit_url
    assert_response :success
  end

  test "should get update" do
    get pgp_strategies_update_url
    assert_response :success
  end

end

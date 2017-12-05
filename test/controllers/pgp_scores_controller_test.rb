require 'test_helper'

class PgpScoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pgp_score = pgp_scores(:one)
  end

  test "should get index" do
    get pgp_scores_url
    assert_response :success
  end

  test "should get new" do
    get new_pgp_score_url
    assert_response :success
  end

  test "should create pgp_score" do
    assert_difference('PgpScore.count') do
      post pgp_scores_url, params: { pgp_score: {  } }
    end

    assert_redirected_to pgp_score_url(PgpScore.last)
  end

  test "should show pgp_score" do
    get pgp_score_url(@pgp_score)
    assert_response :success
  end

  test "should get edit" do
    get edit_pgp_score_url(@pgp_score)
    assert_response :success
  end

  test "should update pgp_score" do
    patch pgp_score_url(@pgp_score), params: { pgp_score: {  } }
    assert_redirected_to pgp_score_url(@pgp_score)
  end

  test "should destroy pgp_score" do
    assert_difference('PgpScore.count', -1) do
      delete pgp_score_url(@pgp_score)
    end

    assert_redirected_to pgp_scores_url
  end
end

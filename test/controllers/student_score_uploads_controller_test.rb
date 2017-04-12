require 'test_helper'

class StudentScoreUploadsControllerTest < ActionController::TestCase
  setup do
    @student_score_upload = student_score_uploads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_score_uploads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_score_upload" do
    assert_difference('StudentScoreUpload.count') do
      post :create, student_score_upload: {  }
    end

    assert_redirected_to student_score_upload_path(assigns(:student_score_upload))
  end

  test "should show student_score_upload" do
    get :show, id: @student_score_upload
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @student_score_upload
    assert_response :success
  end

  test "should update student_score_upload" do
    patch :update, id: @student_score_upload, student_score_upload: {  }
    assert_redirected_to student_score_upload_path(assigns(:student_score_upload))
  end

  test "should destroy student_score_upload" do
    assert_difference('StudentScoreUpload.count', -1) do
      delete :destroy, id: @student_score_upload
    end

    assert_redirected_to student_score_uploads_path
  end
end

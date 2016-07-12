require 'test_helper'

class AssessmentVersionsControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "staff"]
  test "should get new" do
    allowed_roles.each do |r|
      load_session(r)
      
      assess = Assessment.first
      version = AssessmentVersion.new
      get :new, :assessment_id => assessment.id
      assert_response :success
      assert assigns(:version).new_record?
      assert_equal assigns(:assessment), assess
    end
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end

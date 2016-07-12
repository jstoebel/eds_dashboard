require 'test_helper'

class AssessmentVersionsControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "staff"]
  test "should get new" do
    
    allowed_roles.each do |r|
      load_session(r)
      assess = FactoryGirl.create(:assessment)
      version = AssessmentVersion.new
      get :new, :assessment_id => assess.id
      assert_response :success
      assert assigns(:version).new_record?
      assert_equal assigns(:assessment), assess
    end
  end

  test "should get create" do
    allowed_roles.each do |r|
      load_session(r)
      assess = FactoryGirl.create(:assessment)
      version = AssessmentVersion.new
      create_params = {:assessment_id => assess.id}
      post :create, create_params
      assessment_params = create_params[:assessment_version]
      expected_assessment = AssessmentVersion.new assessment_params
      assert assigns(:assessment).valid?, assigns(:assessment).inspect
      assert_redirected_to assessment_version_path
    end
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

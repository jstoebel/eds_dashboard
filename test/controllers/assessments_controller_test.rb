require 'test_helper'
require 'factory_girl'
require 'application_controller'
require 'test_teardown'

class AssessmentsControllerTest < ActionController::TestCase
  
  allowed_roles = ["admin", "staff", "staff", "student labor"]
  
  test "should get index" do
    allowed_roles.each do |r|
      load_session(r)
      assess = Assessment.all
      get :index
      assert_response :success
      assert_equal assigns(:assessment), assess
    end
  end
  
  test "should get new" do
    allowed_roles.each do |r|
      load_session(r)
      get :new
      assert_response :success
      assert assigns(:assessment).new_record?
    end
  end
  
  test "should post create" do
    #How does this test whether saved?
    allowed_roles.each do |r|
      load_session(r)
      create_params = {:name => "test name", :description => "test descrip"}
      post :create, {:assessment => create_params}
      assert assigns(:assessment).valid?
      assert_redirected_to(assessments_path)
      assert_equal flash[:notice], "Created Assessment #{assigns(:assessment).name}."
    end
  end
  
  test "should not post create" do
    allowed_roles.each do |r|
      load_session(r)
      create_params = {:name => nil, :description => "test descrip"}
      post :create, {:assessment => create_params}
      assert_not assigns(:assessment).valid?
      assert_response(200)    #assert on the same page
    end
  end
  
  
  ##Unauthorized users

  test "should not get index bad role" do    #I think this fails because I don't know the actual allowed roles
    (role_names - allowed_roles).each do |r|
      load_session(r)
      assess = Assessment.all
      assert_redirected_to "/access_denied"
    end
  end
  
  test "should not post create bad role" do
  end



  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

end

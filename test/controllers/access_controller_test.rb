require 'test_helper'
require 'test_teardown'
class AccessControllerTest < ActionController::TestCase

  include TestTeardown
  
  test "should get index" do
    role_names.each do |r|    #iterating over all possible roles
      load_session(r)
      get :index
      assert_response :success
    end

  end

  test "should get access_denied" do
    get :access_denied
    assert_redirected_to "/access_denied.html"
  end

  test "should post logout" do
    post :logout
    assert_redirected_to "/logout_confirm.html"
  end

  test "logout should clear session" do
    load_session("admin")
    get :logout
    assert_nil session[:user], "session[:user] is not nil"
    assert_nil session[:role], "session[:role] is not nil"
    assert_nil session[:view_as], "session[:view_as] is not nil"
  end

  test "admin should change psudo status" do
    #tests that admin can change their view_as to advisor (2)
    load_session("admin")
    post :change_psudo_status, {"view_as" => "2"}

    #should be redirected to index
    assert_redirected_to root_path

    #session[:view_as] should be assigned
    assert session[:view_as] == 2, "view_as is not 2"
  end

  test "non admin should not change psudo status" do
    #tests that all non admin roles can't change their view_as to advisor (2)
    (role_names - ["admin"]).each do |r|
      load_session(r)
      post :change_psudo_status, {"view_as" => "2"}

      #should be redirected to index
      assert_redirected_to "/access_denied"
    end
  end

end

require 'test_helper'
class AccessControllerTest < ActionController::TestCase

  role_names = Role.all.pluck :RoleName

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

  (Role.all.pluck :RoleName).each do |role_name|
    describe "as "
  end

  describe "change status" do
    before do
      @user = FactoryGirl.create :user
    end

    ["development", "test"].each do |env|
      test "allowed as #{env}" do
        Rails.stub(env: ActiveSupport::StringInquirer.new(env))

      end
    end

    test "not allowed in production" do

    end
  end

  # describe "should not change psudo status" do
  #   # changing psudo-status is not permitted in production reguardless of role
  #   role_names.each do |r|
  #     test "as #{r}" do
  #       load_session(r)
  #       post :change_psudo_status, {"view_as" => "2"}
  #
  #       #should be redirected to index
  #       assert_redirected_to "/access_denied"
  #       assert_nil session[:view_as]
  #     end
  #   end
  # end

end

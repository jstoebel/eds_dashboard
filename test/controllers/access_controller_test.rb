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

  role_names.each do |r|
    describe "as #{r}" do

    before do
      load_session(r)
      user = User.find_by :UserName => session[:user]
      @original_role = user.role
    end

      describe "change status" do

        ["development", "test"].each do |env|
          test "allowed as #{env}" do
            # Rails.stub(env: ActiveSupport::StringInquirer.new(env))s

            Rails.instance_variable_set("@_env", ActiveSupport::StringInquirer.new(env))
            post :change_psudo_status, {"view_as" => "2"}
            user = User.find_by :UserName => session[:user]
            assert_equal user.role.RoleName, "advisor"
          end
        end # envs loop

        # test "not allowed in production" do
        #   # Rails.stub(env: ActiveSupport::StringInquirer.new("production"))
        #   # byebug
        #   Rails.instance_variable_set("@_env", ActiveSupport::StringInquirer.new("production"))
        #   post :change_psudo_status, {"view_as" => "2"}
        #   assert_redirected_to "/access_denied"
        #   assert_equal session[:role], @original_role.RoleName
        # end

      end # inner describe
    end # outer describe
  end # roles loop


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

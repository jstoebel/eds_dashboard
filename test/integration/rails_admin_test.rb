require "test_helper"

class RailsAdminTest < ActionDispatch::IntegrationTest
  allowed_roles = ["admin"]
  all_roles = Role.all.pluck :RoleName

  test "gets admin" do
    request_admin("admin")
    assert_response :success
  end

  describe "doesn't get admin -- bad role" do
    ["staff", "advisor", "stu_labor"].each do |r|
      test "as #{r}" do
        request_admin(r)
        assert_redirected_to "/access_denied"
      end
    end
  end

  test "doesn't get admin, no role" do
    get '/admin', env: { "REMOTE_USER" => nil}
    assert_redirected_to "/access_denied"
  end

  private
  def request_admin(role_name)
    user = FactoryGirl.create role_name.to_sym
    get '/admin', env: { "REMOTE_USER" => user.andand.UserName}
  end

end

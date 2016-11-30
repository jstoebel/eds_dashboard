require "test_helper"

class RailsAdminTest < ActionDispatch::IntegrationTest
  allowed_roles = ["admin"]
  all_roles = Role.all.pluck :RoleName

  test "gets admin" do
    request_admin("admin")
    assert_response :success
  end

  describe "doesn't get admin" do
    (all_roles - allowed_roles + [nil]).each do |r|
      test "as #{r}" do
        request_admin(r)
        assert_redirected_to "/access_denied"
      end
    end
  end

  private
  def request_admin(role_name)
    role = Role.find_by :RoleName => role_name
    user = User.find_by :Roles_idRoles => role.andand.id
    get '/admin', env: { "REMOTE_USER" => user.andand.UserName}
  end

end

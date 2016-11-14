require 'test_helper'

class RailsAdminTest < ActionDispatch::IntegrationTest

  test "spam" do
    puts session
    # s = open_session
    # s.session.data

  end

  # before do
  #   @session =
  # end
  #
  # describe "as admin" do
  #   before do
  #     puts session[:user]
  #     # role = Role.where(RoleName: "admin").first
  #     # user = User.where(Roles_idRoles: role.idRoles).first
  #     # session[:user] = user.UserName
  #     # session[:role] = role.RoleName
  #   end
  #
  #   test "admin can access" do
  #     get "/admin"
  #     assert_response :success
  #   end
  # end

end

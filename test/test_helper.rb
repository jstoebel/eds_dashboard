ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/fail_fast'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  self.set_fixture_class adm_tep: AdmTep,
							banner_terms: BannerTerm
  # Add more helper methods to be used by all tests here...

  # Rails.application.load_seed   #load seed data

  def py_assert(expected, actual)
  	#an assertion in the style of python unittest. 
  	#Two arguments are compared, and the error message is automaticlaly populated
    assert(expected==actual, "Expected value #{expected} does not equal #{actual}.")
  end

  def role_names
    return Role.all.map {|i| i.RoleName}
  end

  def set_role(role)
    session[:role] = role 
  end

  def load_session(role)
    #loads up session data with a user
    #role: name of role to be loaded (string)
    role = Role.where(RoleName: role).first
    user = User.where(Roles_idRoles: role.idRoles).first
    session[:user] = user.UserName
    session[:role] = role.RoleName
  end


  # def roles_test 
  #   test_roles = Proc.new {
  #   #role_names: array of roles to test
  #   #action: the action to test (symbol)
  #   #outcome: the expected outcome (symbol)
  #   |roles, action, outcome|
  #     roles.each do |r|  #iterate over each role, each should allow access
  #       # set_role(r)
  #       session[:role] = r
  #       get action
  #       assert_response outcome
  #     end
  #   }
  #   return test_roles
  # end


  # def set_admin
  #   #sets session data for advisor
  #   session[:role] = "admin"
  # end

  # def set_advisor
  #   #sets session data for advisor
  #   session[:role] = "advisor"
  # end

  # def set_staff
  #   #sets session data for staff
  #   session[:role] = "staff"
  # end

  # def set_stu_labor
  #   #sets session data for student labor
  #   session[:role] = "stu_labor"
  # end

  # def set_noone
  #   session[:role] = nil
  # end
end

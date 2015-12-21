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

end

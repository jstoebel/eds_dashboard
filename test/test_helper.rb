ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
#require 'minitest/fail_fast'

class ActiveSupport::TestCase
  Rake::Task["db:fixtures:load"].invoke
  fixtures :all

  self.set_fixture_class adm_tep: AdmTep,
              banner_terms: BannerTerm 

  # Rails.application.load_seed   #load seed data

  def py_assert(expected, actual)
  	#an assertion in the style of python unittest. 
  	#Two arguments are compared, and the error message is automaticlaly populated
    assert(expected==actual, "Expected value #{expected} does not equal #{actual}.")
  end

  def get_user
    user = User.find(session[:user])
    user.view_as = session[:view_as]
    return user
  end

  def role_names
    roles =  Role.all.map {|i| i.RoleName}
    return roles.to_a
  end

  def set_role(role)
    session[:role] = role 
  end

  def load_session(r)
    #loads up session data with a user
    #role: name of role to be loaded (string)
    role = Role.where(RoleName: r).first
    user = User.where(Roles_idRoles: role.idRoles).first
    session[:user] = user.UserName
    session[:role] = role.RoleName
  end

  def attach_letter(app)
    #creates a file and associates it with the application
    letter = StudentFile.create({
        :Student_Bnum => app.student.id,
        :active => true,
        :doc => fixture_file_upload('test_file.txt')
      })

    app.student_file_id = letter.id
    return letter
  end

end

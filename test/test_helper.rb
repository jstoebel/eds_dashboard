ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
# require 'minitest/fail_fast'
require 'minitest/unit'
require 'mocha/mini_test'


# mocking out secrets needed in the test suite.
test_secrets = {
  "APP_EMAIL_DOMAIN" => "test.com",
  "APP_EMAIL_USERNAME" => "test_user@test.com",
  "APP_EMAIL_ADDRESS" => "test_user@test.com",
  "APP_EMAIL_PASSWORD" => "password123",
  "APP_ADMIN_EMAIL" => "admin@test.com"
}

SECRET.merge! test_secrets
class ActiveSupport::TestCase

  Rake::Task["db:seed"].execute
  # Rake::Task["db:fixtures:load"].execute
  fixtures :all

  self.set_fixture_class adm_tep: AdmTep,
              banner_terms: BannerTerm

  # Rails.application.load_seed   #load seed data

  def teardown
      #rm -rf public/student_files/test
      FileUtils.rm_rf('public/student_files/test')
      FileUtils.rm_rf('test/test_temp')
      ActionMailer::Base.deliveries = [] # clear out emails
  end

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
    puts session[:user]
    session[:user] = user.UserName
    session[:role] = role.RoleName
  end

  def attach_letter(app)
    #creates a file and associates it with the application
    letter = StudentFile.create({
        :student_id => app.student.id,
        :active => true,
        :doc => fixture_file_upload('test_file.txt')
      })

    app.student_file_id = letter.id
    return letter
  end

  def pop_transcript(stu, n, grade_pt, term)
    #gives student n courses all with the given grade
    #all courses are in the term given

    courses = n.times.map {|i| FactoryGirl.build(:transcript, {
        :student_id => stu.id,
        :credits_attempted => 4.0,
        :credits_earned => 4.0,
        :gpa_include => true,
        :term_taken => term.id,
        :grade_pt => grade_pt,
        :grade_ltr => Transcript.g_to_l(grade_pt)
      })
    }

    courses.each { |i| i.save}
  end

  def pop_praxisI(stu, passing)

    #for each required test, make attrs for a praxis_result
    p1_tests = PraxisTest.where({:TestFamily => 1, :CurrentTest => true})

    praxis_attrs = p1_tests.map { |test|
      FactoryGirl.attributes_for :praxis_result, {
        :student_id => stu.id,
        :praxis_test_id =>  test.id,
        :test_score => (passing ? test.CutScore : test.CutScore-1),
        :test_date => Date.today,
        :reg_date => Date.today - 30
      }
     }

     praxis_attrs.map { |t| PraxisResult.create t }
  end

end

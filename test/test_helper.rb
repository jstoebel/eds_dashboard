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

  # Rails.application.load_seed   #load seed data
  fixtures :all
  self.set_fixture_class adm_tep: AdmTep,
            banner_terms: BannerTerm
  def teardown
      #rm -rf public/student_files/test
      FileUtils.rm_rf('public/student_files/test')
      FileUtils.rm_rf('test/test_temp')
      ActionMailer::Base.deliveries = [] # clear out emails
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
    user = FactoryGirl.create :user, :Roles_idRoles =>  role.id
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

    p1_tests = FactoryGirl.create_list :praxis_test, 3, {:TestFamily => 1, :CurrentTest => true}

    praxis_attrs = p1_tests.map { |test|
      FactoryGirl.create :praxis_result, {
        :student_id => stu.id,
        :praxis_test_id =>  test.id,
        :test_score => (passing ? test.CutScore : test.CutScore-1),
        :test_date => Date.today,
        :reg_date => Date.today - 30
      }
     }

  end

  def make_advisor(user)
    # make an advisor for this user
    adv = user.tep_advisor
    if user.tep_advisor.blank?
      adv = FactoryGirl.create :tep_advisor, :user => user
    end
    return adv
  end

  def make_student(user)
    # make a student for this user
    # return the student

    adv = make_advisor(user)
    this_term = FactoryGirl.create :banner_term, {:StartDate => 5.days.ago,
      :EndDate => 5.days.from_now}

    course = FactoryGirl.create :transcript, {:instructors => "FirstName, LastName {#{adv.AdvisorBnum}}",
      :banner_term => this_term
    }
    return course.student
  end

  def make_advisee(user)
    # make an advisee for this user
    # return the student

    adv = make_advisor(user)
    assignment = FactoryGirl.create :advisor_assignment, :tep_advisor => adv
    return assignment.student

  end

end

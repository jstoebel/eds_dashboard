# == Schema Information
#
# Table name: students
#
#  id               :integer          not null, primary key
#  Bnum             :string(9)        not null
#  FirstName        :string(45)       not null
#  PreferredFirst   :string(45)
#  MiddleName       :string(45)
#  LastName         :string(45)       not null
#  PrevLast         :string(45)
#  ProgStatus       :string(45)       default("Prospective")
#  EnrollmentStatus :string(45)
#  Classification   :string(45)
#  CurrentMajor1    :string(45)
#  CurrentMajor2    :string(45)
#  TermMajor        :integer
#  PraxisICohort    :string(45)
#  PraxisIICohort   :string(45)
#  CellPhone        :string(45)
#  CurrentMinors    :string(45)
#  Email            :string(100)
#  CPO              :string(45)
#

require 'test_helper'
require 'test_teardown'
class StudentsControllerTest < ActionController::TestCase
  include TestTeardown
  allowed_roles = ["admin", "staff", "advisor"]

  test "admin should get index" do
      load_session("admin")
      get :index
      assert_response :success
      user = User.find_by(:UserName => session[:user])
      ability = Ability.new(user)
      assert_equal Student.all.by_last.current.select {|r| ability.can? :read, r }, assigns(:students)
  end

  test "staff should get index" do

      load_session("staff")
      get :index
      assert_response :success
      user = User.find_by(:UserName => session[:user])
      ability = Ability.new(user)
      assert_equal Student.all.by_last.current.select {|r| ability.can? :read, r }, assigns(:students)
  end

  test "advisor should get index" do
      load_session("advisor")
      get :index
      assert_response :success
      user = User.find_by(:UserName => session[:user])
      ability = Ability.new(user)
      assert_equal Student.all.by_last.current.select {|r| ability.can? :read, r }, assigns(:students)
  end

  test "should get show" do
    allowed_roles.each do |r|
      load_session(r)
      stu = Student.first
      get :show, :id => stu.AltID
      assert_response :success
      assert_equal stu, assigns(:student)

    end
  end

  ## TESTS FOR UNPERMITTED ROLES

  test "should not get show bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :show, {:id => Student.first.id}
      assert_redirected_to "/access_denied"
    end
  end

end

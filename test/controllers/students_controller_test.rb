require 'test_helper'

class StudentsControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "staff", "advisor"]

  test "admin should get index" do
      load_session("admin")
      get :index
      assert_response :success
      user = User.find(session[:user])
      ability = Ability.new(user)
      assert_equal Student.all.current.by_last.select {|r| ability.can? :read, r }, assigns(:students)
  end

  test "staff should get index" do

      load_session("staff")
      get :index
      assert_response :success
      user = User.find(session[:user])
      ability = Ability.new(user)
      assert_equal Student.all.current.by_last.select {|r| ability.can? :read, r }, assigns(:students)
  end

  test "advisor should get index" do
      load_session("advisor")
      get :index
      assert_response :success
      user = User.find(session[:user])
      ability = Ability.new(user)
      assert_equal Student.all.current.by_last.select {|r| ability.can? :read, r }, assigns(:students)
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

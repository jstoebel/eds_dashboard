require 'test_helper'

class StudentsControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "advisor", "staff"]
  test "should get index" do
    allowed_roles.each do |r|
      load_session(r)
      get :index

      assert_response :success
      user = User.find(session[:user])
      ability = Ability.new(user)
      assert_equal Student.all.current.by_last.select {|r| ability.can? :read, r }, assigns(:students)
    end
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

  # test "should get edit" do
  #   get :edit
  #   assert_response :success
  # end

  # test "should get update" do
  #   get :update
  #   assert_response :success
  # end

end

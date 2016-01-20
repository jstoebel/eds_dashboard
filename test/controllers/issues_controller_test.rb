require 'test_helper'

class IssuesControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "advisor"]



  test "should get new" do
    allowed_roles.each do |r|
      load_session(r)
      issue = Issue.new
      student = Student.first
      get :new, :student_id => student.id
      assert_response :success
      py_assert assigns(:issue), issue
      py_assert assigns(:student), student
    end
  end

  # test "should get create" do
  #   get :create
  #   assert_response :success
  # end

  # test "should get show" do
  #   get :show
  #   assert_response :success
  # end

end

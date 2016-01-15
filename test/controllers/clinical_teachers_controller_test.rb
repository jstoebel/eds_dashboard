require 'test_helper'

class ClinicalTeachersControllerTest < ActionController::TestCase
  test "should get index" do
    role_names.each do |r|
      load_session(r)
      get :index
      assert_response :success
      py_assert assigns(:teachers), ClinicalTeacher.all

    end
  end

  # test "should get show" do
  #   get :show
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit
  #   assert_response :success
  # end

  # test "should get update" do
  #   get :update
  #   assert_response :success
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should get create" do
  #   get :create
  #   assert_response :success
  # end

end

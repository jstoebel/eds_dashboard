require 'test_helper'

class ClinicalAssignmentsControllerTest < ActionController::TestCase

  #everyone should be allowed to access this resource

  test "should get index" do
    role_names.each do |r|
      load_session(r)
      get :index
      assert_response :success
      py_assert assigns(:assignments), ClinicalAssignment.where(Term: @term).select {|a| can? :read, a }
    end
  end

  test "should get new" do
    role_names.each do |r|
      load_session(r)
      get :new
      assert_response :success
      assert assigns(:assignment).new_record? and not assigns(:assignment).changed?
      py_assert assigns(:students), Student.current.by_last.select{|s| can? :read, s}
      py_assert assigns(:teachers), ClinicalTeacher.all
      py_assert(assigns(:current_term), ApplicationController.helpers.current_term(exact: false, plan_b: :forward))
    end
  end

  test "should post create" do
    role_names.each do |r|
      load_session(r)
      #build request
      stu = Student.first
      term = ApplicationController.helpers.current_term(:)
      start_date = Date.today
      end_date = start_date + 1
      teacher = ClinicalTeacher.first

      #build expected new assignment
      expected_assignment = ClinicalAssignment.new {
        Bnum: stu.Bnum, 
        clinical_teacher_id: teacher.id,

        :Term, 
        :CourseID, 
        :Level,
        :StartDate,
        :EndDate
      }


      post :create, :clinical_assignment => {:Bnum => stu.Bnum,
       :clinical_teacher_id => teacher.id,
       :StartDate => start_date.strftime("%m/%d/%Y"),
       :EndDate => emd_date.strftime("%m/%d/%Y")},
     "commit"=>"Create Assignment"}

      assert_response :success
      py_assert assigns(:assignment), 

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

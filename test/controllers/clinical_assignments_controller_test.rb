require 'test_helper'

class ClinicalAssignmentsControllerTest < ActionController::TestCase

  #everyone should be allowed to access this resource

  test "should get index" do
    role_names.each do |r|
      load_session(r)
      get :index
      assert_response :success
      term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)
      py_assert assigns(:assignments).to_a, (ClinicalAssignment.where(Term: term).select {|a| can? :read, a }).to_a
      py_assert assigns(:term), ApplicationController.helpers.current_term(exact: false, plan_b: :back)
    end
  end

  test "should get new" do
    role_names.each do |r|
      load_session(r)
      get :new
      assert_response :success
      assert assigns(:assignment).new_record? and not assigns(:assignment).changed?
      check_form_setup
    end
  end

  test "should post create" do
    role_names.each do |r|
      load_session(r)

      current_assignment = ClinicalAssignment.first

      teacher = ClinicalTeacher.first
      stu = Student.first
      expected_term = ApplicationController.helpers.current_term(exact: false, plan_b: :forward)
      expected_assignment_id = [stu.Bnum, expected_term.BannerTerm.to_s, teacher.id.to_s, "???"].join("-")

      #delete current_assignment so new assignment can go through
      current_assignment.destroy

      post :create, :clinical_assignment => {
        :Bnum => stu.Bnum,
        :clinical_teacher_id => teacher.id,
        :StartDate => expected_term.StartDate.strftime("%m/%d/%Y"),
        :EndDate => expected_term.EndDate.strftime("%m/%d/%Y")
        },
      :commit =>"Create Assignment"

      assert_redirected_to clinical_assignments_path
      py_assert assigns(:assignment), ClinicalAssignment.find(expected_assignment_id)

    end
  end

test "should not post create bad record" do
  #can't create record due to a record not saving
    role_names.each do |r|
      load_session(r)

      current_assignment = ClinicalAssignment.first

      teacher = ClinicalTeacher.first
      stu = Student.first
      expected_term = ApplicationController.helpers.current_term(exact: false, plan_b: :forward)
      expected_assignment_id = [stu.Bnum, expected_term.BannerTerm.to_s, teacher.id.to_s, "???"].join("-")

      post :create, :clinical_assignment => {
        :Bnum => stu.Bnum,
        :clinical_teacher_id => teacher.id,
        :StartDate => expected_term.EndDate.strftime("%m/%d/%Y"),
        :EndDate => ((expected_term.StartDate) -1 ).strftime("%m/%d/%Y")  #end before start
        },
      :commit =>"Create Assignment"

      assert_response :success

     
    end
  end

  test "should not post create integrity error" do
    #should get an integrity error
    role_names.each do |r|
      load_session(r)

      current_assignment = ClinicalAssignment.first

      teacher = ClinicalTeacher.first
      stu = Student.first
      expected_term = ApplicationController.helpers.current_term(exact: false, plan_b: :forward)
      expected_assignment_id = [stu.Bnum, expected_term.BannerTerm.to_s, teacher.id.to_s, "???"].join("-")

      post_params = {
          :Bnum => "bad id",
          :clinical_teacher_id => teacher.id,
          :StartDate => expected_term.StartDate.strftime("%m/%d/%Y"),
          :EndDate => expected_term.EndDate.strftime("%m/%d/%Y")
          }
      assert_raises(ActiveRecord::InvalidForeignKey) { post :create, 
        :clinical_assignment => post_params }

    end
  end

  test "should get edit" do
    role_names.each do |r|
      load_session(r)
      assert ClinicalAssignment.all.size > 0
      assignment = ClinicalAssignment.first
      get :edit, {:id => assignment.AltID}
      assert_response :success
      py_assert assigns(:assignment), assignment
      check_form_setup

    end
  end

  test "should not get edit bad id" do
    role_names.each do |r|
      load_session(r)
      assert ClinicalAssignment.all.size > 0
      assignment = ClinicalAssignment.first
      
      assert_raises(ActionView::Template::Error) { get :edit, {:id => "bad id"} }
    end
  end


  test "should post update" do
    role_names.each do |r|
      load_session(r)
      assignment = ClinicalAssignment.first
      assignment.Level = 3
      update_params = {:Level => assignment.Level}

      post :update, {:id => assignment.id, :clinical_assignment => update_params}

      assert_redirected_to clinical_assignments_path
      assert assigns(:assignment), assignment
    end
  end

  test "should not post update bad id" do
    role_names.each do |r|
      load_session(r)
      assignment = ClinicalAssignment.first
      assignment.Level = 3
      update_params = {:Level => assignment.Level}

      assert_raises(ActiveRecord::RecordNotFound) {
        post :update, {:id => "bad id", :clinical_assignment => update_params}
      }
    end
  end

  test "should post choose" do
    role_names.each do |r|
      load_session(r)
      term = ApplicationController.helpers.current_term({:exact => false, :plan_b => :back})
      term_int = term.BannerTerm

      post :choose, {
        :clinical_assignment_id => "pick",
        :banner_term => {
          :menu_terms => term_int
        }
      }

      assert_redirected_to banner_term_clinical_assignments_path(term_int)

      term = BannerTerm.find(term_int)
      assert assigns(:assignments).to_a, (ClinicalAssignment.where(Term: term).select {|a| can? :read, a }).to_a
      py_assert assigns(:term), term_int.to_s
    end
  end

  private

  def check_form_setup
    py_assert assigns(:students), Student.current.by_last.select{|s| can? :read, s}
    py_assert assigns(:teachers), ClinicalTeacher.all
    py_assert assigns(:current_term), ApplicationController.helpers.current_term(exact: false, plan_b: :forward)
  end

end

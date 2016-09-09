# == Schema Information
#
# Table name: clinical_assignments
#
#  student_id          :integer          not null
#  id                  :integer          not null, primary key
#  clinical_teacher_id :integer          not null
#  Term                :integer          not null
#  CourseID            :string(45)       not null
#  Level               :string(45)
#  StartDate           :date
#  EndDate             :date
#

require 'test_helper'
require 'test_teardown'
class ClinicalAssignmentsControllerTest < ActionController::TestCase
  include TestTeardown
  #everyone should be allowed to access this resource

  test "should get index" do
    role_names.each do |r|
      load_session(r)
      get :index
      assert_response :success
      term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)
      assert_equal assigns(:assignments).to_a, (ClinicalAssignment.where(Term: term).select {|a| can? :read, a }).to_a
      assert_equal assigns(:term), ApplicationController.helpers.current_term(exact: false, plan_b: :back)
    end
  end

  # TODO Why doesn't this work??? Always fails on the second role.
  test "should get new" do
    role_names.each do |r|

      load_session(r)

      get :new
      assert_response :success
      assert assigns(:assignment).new_record? and not assigns(:assignment).changed?

      user = User.find_by(:UserName => session[:user])

      abil = Ability.new(user)
      check_form_setup
    end
  end

  test "should post create" do
    role_names.each do |r|
      load_session(r)

      current_assignment = ClinicalAssignment.first

      teacher = ClinicalTeacher.first
      stu = Student.first
      expected_term = BannerTerm.current_term(exact: false, plan_b: :forward)

      #delete current_assignment so new assignment can go through
      current_assignment.destroy

      # assert false, expected_term.StartDate.strftime("%m/%d/%Y")

      create_params = {:clinical_assignment => {
              :student_id => stu.id,
              :clinical_teacher_id => teacher.id,
              :StartDate => expected_term.StartDate.strftime("%Y/%m/%d"),
              :EndDate => expected_term.EndDate.strftime("%Y/%m/%d")
              },
              :commit =>"Create Assignment"
            }

      post :create, create_params
      assignment_params = create_params[:clinical_assignment]
      expected_assignment = ClinicalAssignment.new assignment_params

      #filter down the expected and the actual based on the keys we want to compare.
      expected_filtered = expected_assignment.attributes.select { |k, v| assignment_params.include?(k.to_sym)}
      actual_filtered = assigns(:assignment).attributes.select { |k, v| assignment_params.include?(k.to_sym)}

      assert_equal expected_filtered, actual_filtered

      assert assigns(:assignment).valid?, assigns(:assignment).inspect
      assert_redirected_to clinical_assignments_path

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

  # TODO Why doesn't this work??? Always fals on the second role.
  test "should get edit" do
    role_names.each do |r|
      load_session(r)
      assert ClinicalAssignment.all.size > 0
      assignment = ClinicalAssignment.first
      get :edit, {:id => assignment.id}
      assert_response :success
      assert_equal assigns(:assignment), assignment
      check_form_setup

    end
  end

  test "should not get edit bad id" do
    role_names.each do |r|
      load_session(r)
      assert ClinicalAssignment.all.size > 0
      assignment = ClinicalAssignment.first

      assert_raises(ActiveRecord::RecordNotFound) { get :edit, {:id => "bad id"} }
    end
  end


  test "should post update" do
    role_names.each do |r|
      load_session(r)
      assignment = ClinicalAssignment.first
      assignment.Level = 3
      update_params = assignment.attributes

      post :update, {:id => assignment.id, :clinical_assignment => update_params}
      assert assigns(:assignment).valid?, assigns(:assignment).inspect
      assert_redirected_to banner_term_clinical_assignments_path(assigns(:assignment).banner_term.id)
      assert_equal assigns(:assignment), assignment
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
      assert_equal assigns(:term), term_int.to_s
    end
  end

  private

  def check_form_setup
    user = User.find_by(:UserName => session[:user])
    abil = Ability.new(user)
    
    # TODO figure out why this doesn't work as expected
    # expected_students = Student.by_last.where({:EnrollmentStatus => "Active Student"}).current.select{|s| abil.can? :index, s}
    # assert_equal expected_students.to_a, assigns(:students).to_a

    assert_equal assigns(:teachers), ClinicalTeacher.all
    assert_equal assigns(:current_term), ApplicationController.helpers.current_term(exact: false, plan_b: :forward)
  end

end

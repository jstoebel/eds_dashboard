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

class ClinicalAssignmentsControllerTest < ActionController::TestCase
  #everyone should be allowed to access this resource

  allowed_roles = Role.all.pluck :RoleName

  describe "get index" do
    allowed_roles.each do |r|
      test "as #{r}" do
        load_session(r)
        get :index
        assert_response :success
        term = ApplicationController.helpers.current_term(exact: false, plan_b: :back)
        assert_equal assigns(:assignments).to_a, (ClinicalAssignment.where(Term: term).select {|a| can? :read, a }).to_a
        assert_equal assigns(:term), ApplicationController.helpers.current_term(exact: false, plan_b: :back)
      end
    end
  end

  describe "get new" do
    allowed_roles.each do |r|
      test "as #{r}" do
        load_session(r)
        get :new
        assert_response :success
        assert assigns(:assignment).new_record? and not assigns(:assignment).changed?
        check_form_setup
      end
    end
  end

  describe "create" do

    allowed_roles.each do |r|
      describe "as #{r}" do
        before do
          load_session(r)

          user = User.find_by :UserName => session[:user]

          advisor = FactoryGirl.create :tep_advisor, :user_id => user.id

          adv_assign = FactoryGirl.create :advisor_assignment, :tep_advisor => advisor

          FactoryGirl.create_list :clinical_teacher, 5
          FactoryGirl.create_list :student, 5
          term = (FactoryGirl.create :banner_term, :StartDate => 5.days.ago,
          :EndDate => 5.days.from_now
          )

          @assignment = FactoryGirl.build :clinical_assignment, {
            :student_id => adv_assign.student.id,
            :banner_term => term,
            :StartDate => term.StartDate,
            :EndDate => term.EndDate,
            :transcript => (FactoryGirl.create :transcript)
          }

        end

        test "as #{r} should create" do
          post :create, {:clinical_assignment => @assignment.attributes}

          expected_attrs = @assignment.attributes
          actual_attrs = assigns(:assignment).attributes

          assert assigns(:assignment).valid?, assigns(:assignment).errors.full_messages
          assert_equal expected_attrs.except("id"), actual_attrs.except("id")
          assert_redirected_to clinical_assignments_path
        end

        test "as #{r} should not create -- bad params" do
          #can't create record due to a record not saving
          @assignment.clinical_teacher_id = nil
          post :create, {:clinical_assignment => @assignment.attributes}
          assert_not assigns(:assignment).valid?, assigns(:assignment).errors.full_messages
          assert_response :success
          check_form_setup

        end # test
      end # inner describe

    end # roles loop
  end # describe

  describe "edit" do

    allowed_roles.each do |r|
      before do
        load_session(r)
      end

      test "should get" do
        FactoryGirl.create_list :clinical_teacher, 5
        FactoryGirl.create_list :student, 5
        assignment = FactoryGirl.create :clinical_assignment
        get :edit, {:id => assignment.id}
        assert_response :success
        assert_equal assigns(:assignment), assignment
        check_form_setup
      end

      test "should not get -- bad id" do
        assert_raises(ActiveRecord::RecordNotFound) { get :edit, {:id => "bad id"} }
      end # test
    end # roles loop
  end # describe

  describe "update" do

    allowed_roles.each do |r|
      before do
        load_session(r)

        FactoryGirl.create_list :clinical_teacher, 5
        FactoryGirl.create_list :student, 5
        @assignment = FactoryGirl.create :clinical_assignment, {
          :student_id => (FactoryGirl.create :student).id,
          :clinical_teacher_id => (FactoryGirl.create :clinical_teacher).id,
          :Term => (FactoryGirl.create :banner_term).id
        }
        @new_teacher = FactoryGirl.create :clinical_teacher
        @assignment.clinical_teacher_id = @new_teacher.id
        @assignment.save!
        @update_params = {:clinical_teacher_id => @new_teacher.id,
          :StartDate => @assignment.StartDate.strftime("%Y-%m-%d"),
          :EndDate => @assignment.EndDate.strftime("%Y-%m-%d")}
      end

      test "should update" do
        post :update, {:id => @assignment.id, :clinical_assignment => @update_params}

        assert assigns(:assignment).valid?, assigns(:assignment).errors.full_messages
        assert_redirected_to banner_term_clinical_assignments_path(@assignment.banner_term.id)
        assert_equal assigns(:assignment), @assignment
      end

      test "should not update -- bad params" do
        assert_raises(ActiveRecord::RecordNotFound) {
          post :update, {:id => "bad id", :clinical_assignment => @update_params}
        }
      end # test
    end # roles loop
  end # describe

  describe "choose" do
    allowed_roles.each do |r|
      test "should get as #{r}" do
        load_session(r)
        FactoryGirl.create_list :clinical_assignment, 5
        term = FactoryGirl.create :banner_term
        post :choose, {
          :clinical_assignment_id => "pick",
          :banner_term => {
            :menu_terms => term.id
          }
        }

        assert_redirected_to banner_term_clinical_assignments_path(term.id)
        assert assigns(:assignments).to_a, (ClinicalAssignment.where(Term: term).select {|a| can? :read, a }).to_a
        assert_equal assigns(:term).to_s, term.id.to_s
      end
    end
  end

  private

  def check_form_setup
    user = User.find_by(:UserName => session[:user])
    abil = Ability.new(user)

    # TODO figure out why this doesn't work as expected
    # expected_students = Student.by_last.where({:EnrollmentStatus => "Active Student"}).current.select{|s| abil.can? :index, s}
    # assert_equal expected_students.to_a, assigns(:students).to_a

    assert_equal assigns(:teachers).to_a, ClinicalTeacher.by_last.all.to_a
    assert_equal assigns(:current_term), ApplicationController.helpers.current_term(exact: false, plan_b: :forward)
  end

end

# == Schema Information
#
# Table name: students
#
#  id                      :integer          not null, primary key
#  Bnum                    :string(9)        not null
#  FirstName               :string(45)       not null
#  PreferredFirst          :string(45)
#  MiddleName              :string(45)
#  LastName                :string(45)       not null
#  PrevLast                :string(45)
#  EnrollmentStatus        :string(45)
#  Classification          :string(45)
#  CurrentMajor1           :string(45)
#  concentration1          :string(255)
#  CurrentMajor2           :string(45)
#  concentration2          :string(255)
#  CellPhone               :string(45)
#  CurrentMinors           :string(255)
#  Email                   :string(100)
#  CPO                     :string(45)
#  withdraws               :text(65535)
#  term_graduated          :integer
#  gender                  :string(255)
#  race                    :string(255)
#  hispanic                :boolean
#  term_expl_major         :integer
#  term_major              :integer
#  presumed_status         :string(255)
#  presumed_status_comment :text(65535)
#

require 'test_helper'
class StudentsControllerTest < ActionController::TestCase
  self.pre_loaded_fixtures = false
  allowed_roles = ["admin", "staff", "advisor"]
  role_names = Role.all.pluck :RoleName

  before do
    @controller = StudentsController.new
  end


  describe "index" do

    allowed_roles.each do |r|

      describe "as #{r}" do

        before do

          load_session(r)

          @user = User.find_by :UserName => session[:user]
          @my_student = FactoryGirl.create :student

          if @user.tep_advisor.blank?
            @advisor = FactoryGirl.create :tep_advisor, {:user_id => @user.id}
          else
            @advisor = @user.tep_advisor
          end

          AdvisorAssignment.create({:student_id => @my_student.id,
              :tep_advisor_id => @advisor.id
            })

        end

        test "no params" do
          get :index
          abil = Ability.new(@user)

          assert_response :success
          assert Student.by_last.active_student.current.select{|s| abil.can? :read, s}, assigns(:students)
        end

        describe "basic search" do

          fields = [:FirstName, :PreferredFirst, :LastName]

          fields.each do |f|
            test f do
              get :index, params: {:search => @my_student.send(f)}
              assert :success
              assert_equal [@my_student], assigns(:students).to_a
            end
          end

        end

        test "with prev last name" do
          stu_last = @my_student.last_names.first.last_name
          get :index, params: {:search => stu_last}
          assert :success
          assert_equal [@my_student], assigns(:students).to_a
        end

        test "with multiple words" do
          search_str = "#{@my_student.FirstName} spam"
          get :index, params: {:search => search_str}
          assert :success
          assert_equal [@my_student], assigns(:students).to_a
        end

        test "with all" do
          abil = Ability.new(@user)

          get :index, params: {:all => :true}

          assert :success
          assert_equal [@my_student], assigns(:students).to_a
        end

      end # as r

    end # roles loop

  end

  describe "show" do

    role_names.each do |r|

      describe "as #{r}" do

        before do
          load_session(r)
          user = User.find_by :UserName => session[:user]
          @my_student = FactoryGirl.create :student

          if user.tep_advisor.blank?
            advisor = FactoryGirl.create :tep_advisor, {:user_id => user.id}
          else
            advisor = user.tep_advisor
          end

          AdvisorAssignment.create({:student_id => @my_student.id,
              :tep_advisor_id => advisor.id
            })

        end

        test "should get show" do
            get :show, params: {:id => @my_student.AltID}
            assert_response :success
            assert_equal @my_student, assigns(:student)
        end

      end
    end

  end # outer describe

  describe "update presumed status" do

    before do
      @stu = FactoryGirl.create :student
    end

    ["admin", "staff"].each do |r|
      describe "as #{r}" do

        before do
          load_session(r)
        end

        test "updates student" do
          new_params = {presumed_status: "Prospective", presumed_status_comment: "spam" }
          patch :update_presumed_status, params: {:student_id => @stu.id, :student => new_params}
          assert_response :success
          stu = Student.find @stu.id
          new_params.each do |key, value|
            assert_equal value, stu.send(key)
          end

        end

        test "doesn't update student" do
          new_params = {presumed_status: "bad status", presumed_status_comment: "spam" }
          patch :update_presumed_status, params: {:student_id => @stu.id, :student => new_params}
          assert_response :unprocessable_entity
          stu = Student.find @stu.id
          new_params.each do |key, value|
            assert_not_equal value, stu.send(key)
          end
        end

      end # as
    end # loop


    ["advisor", "student labor"].each do |r|
      describe "as #{r}" do
        before do
          load_session(r)
        end
        test "redirects to access_denied" do
          new_params = {presumed_status: "Prospective", presumed_status_comment: "spam" }
          patch :update_presumed_status, params: {:student_id => @stu.id, :student => new_params}
          assert_response :unprocessable_entity
        end # test

      end # describe
    end # loop

  end # outer describe

  describe "get_resources" do

    role_names.each do |r|
      describe "as #{r}" do

        before do
          load_session(r)
          user = User.find_by :UserName => session[:user]
          tep_advisor = FactoryGirl.create :tep_advisor, :user => user
          adv_assign = FactoryGirl.create :advisor_assignment, {
            :tep_advisor_id => tep_advisor.id,
          }
          @stu = adv_assign.student
          @with_student = {:student_id => @stu.id}

        end

        test "details" do
          get :get_resources, params: @with_student
          assert_response :success

          resp = JSON.parse(@response.body)
          expected_hash = {"disable" => false, "menu_name" => "Details",
            "link_url" => student_path(@stu.AltID)}

          assert_equal expected_hash, resp[0] # everyone can do this.

        end

        test "checkpoints" do

          FactoryGirl.create :failing_test, @with_student
          get :get_resources, params: @with_student
          assert_response :success

          resp = JSON.parse(@response.body)
          expected_hash = {"disable" => false, "menu_name" => "Checkpoints",
            "link_url" => student_concern_dashboard_index_path(@stu.id)}

          if ["admin", "advisor"].include? r
            assert_equal expected_hash, resp[1]
          else
            assert_equal true, resp[1]["disable"]
          end
        end

        test "praxis results" do

          FactoryGirl.create :failing_test, @with_student
          get :get_resources, params: @with_student
          assert_response :success

          resp = JSON.parse(@response.body)
          expected_hash = {"disable" => false, "menu_name" => "Praxis Results (#{@stu.praxis_results.size})",
            "link_url" => student_praxis_results_path(@stu.id)}

          assert_equal expected_hash, resp[2]

        end

        test "issues" do
          FactoryGirl.create :issue, @with_student
          get :get_resources, params: @with_student
          assert_response :success

          resp = JSON.parse(@response.body)
          expected_hash = {"disable" => false, "menu_name" => "Issues (#{@stu.issues.select{|u| u.visible}.size})",
            "link_url" => student_issues_path(@stu.AltID)}

            if ["admin", "advisor"].include? r
              assert_equal expected_hash, resp[3]
            else
              assert_equal true, resp[3]["disable"]
            end
        end

        test "student files" do
          FactoryGirl.create :student_file, @with_student
          get :get_resources, params: @with_student
          assert_response :success

          resp = JSON.parse(@response.body)
          expected_hash = {"disable" => false, "menu_name" => "Files (#{@stu.student_files.active.size})",
            "link_url" => student_student_files_path(@stu.AltID)}

          if ["admin", "staff", "advisor"].include? r
            assert_equal expected_hash, resp[4]
          else
            assert_equal true, resp[4]["disable"]
          end
        end

      end # test
    end # roles loop
  end # outer describe
end

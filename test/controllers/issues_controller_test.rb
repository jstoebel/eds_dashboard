# == Schema Information
#
# Table name: issues
#
#  IssueID                  :integer          not null, primary key
#  student_id               :integer          not null
#  Name                     :text(65535)      not null
#  Description              :text(65535)      not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#  visible                  :boolean          default(TRUE), not null
#  positive                 :boolean
#  disposition_id           :integer
#

require 'test_helper'
require 'application_controller'
class IssuesControllerTest < ActionController::TestCase

  allowed_roles = ["admin", "advisor"]
  role_names = Role.all.pluck :RoleName

  test "should get new" do
    allowed_roles.each do |r|
      load_session(r)
      issue = Issue.new
      student = FactoryGirl.create :student
      get :new, :student_id => student.AltID
      assert_response :success
      assert_equal assigns(:student), student
    end
  end

  describe "edit" do

    allowed_roles.each do |r|
      describe "allowed role: #{r}" do
        before do

          load_session(r)
          user = User.find_by :UserName => session[:user]
          stu = make_advisee(user)
          @issue = FactoryGirl.create :issue, {
            :student => stu,
            :tep_advisor => user.tep_advisor
          }
        end

        test "http success" do
          get :edit, :id => @issue.id
          assert_response :success
        end

        test "pulls issue" do
          get :edit, :id => @issue.id
          assert_equal @issue, assigns(:issue)
        end

        test "pulls student" do
          get :edit, :id => @issue.id
          assert_equal @issue.student, assigns(:student)
        end

        test "pulls dispositions" do
          get :edit, :id => @issue.id
          assert_equal Disposition.current.ordered, assigns(:dispositions)
        end

      end # allowed role

    end # for loop
  end

  describe "create" do

    before do
      @issue = FactoryGirl.create :issue
    end

    allowed_roles.each do |r|

      describe "allowed role: #{r}" do

        let(:post_create) { post :create, {:student_id => @issue.student_id,
          :issue => @issue.attributes,
          :issue_update => {:status => "concern"}} }

        before do
          load_session(r)
          @user = User.find_by :UserName => session[:user]
          tep_advisor = FactoryGirl.create :tep_advisor, {:user_id => @user.id}
          @advisor = @user.tep_advisor

          # assign advisor to student
          AdvisorAssignment.create!({:student_id => @issue.student.id,
            :tep_advisor_id => @advisor.id
            })

            @issue.tep_advisors_AdvisorBnum = @advisor.id

        end

        test "creates an issue" do

          assert_difference('Issue.count', 1) do
            post_create
          end
        end

        test "issues match" do

          post_create
          #remove some attrs
          to_exclude = ["IssueID", "created_at", "updated_at"]

          expected_attrs = @issue.attributes.except(*to_exclude)
          actual_attrs = assigns(:issue).attributes.except(*to_exclude)

          assert_equal expected_attrs, actual_attrs
        end

        test "creates issue_update" do

          assert_difference("IssueUpdate.count", 1) do
            post_create
          end

        end

        test "issue_update matches" do
          post_create

          assert_equal 1, assigns(:issue).issue_updates.size

          to_exclude = ["UpdateID", "Issues_IssueID", "tep_advisors_AdvisorBnum", "created_at", "updated_at"]
          expected_attrs = @issue.issue_updates.first.attributes.except(*to_exclude)
          actual_attrs = assigns(:update).attributes.except(*to_exclude)
          assert_equal expected_attrs, actual_attrs

        end

        test "flash notice" do
          post_create
          assert_equal "New issue opened for: #{@issue.student.name_readable}", flash[:notice]
        end

        test "redirects to issues index" do
          post_create
          assert_redirected_to student_issues_path(@issue.student.AltID)
        end

        test "fails and renders new" do
          @issue.Name = nil
          post_create
          assert_response :success
          assert_template 'new'
        end
      end
    end # allowed roles
  end

  describe "index" do
    allowed_roles.each do |r|

      describe "allowed role: #{r}" do
        before do
          load_session(r)
          @user = User.find_by :UserName => session[:user]
          @adv = FactoryGirl.create :tep_advisor, {:user_id => @user.id}
          @abil = Ability.new @user
          @issue = FactoryGirl.create :issue, {:tep_advisors_AdvisorBnum => @adv.id}
        end

        test "gets all issues" do
          get :index
          assert_response :success
          assert_equal assigns(:issues), Issue.all.sorted.visible.select {|issue| @abil.can? :read, issue}.select {|issue| (issue.open?) }
        end

        test "gets issues for student" do

          issue = FactoryGirl.create :issue
          AdvisorAssignment.create!({:student_id => issue.student_id,
            :tep_advisor_id => @adv.id
            })

          get :index, {:student_id => issue.student.id}
          assert_response :success
          assert_equal assigns(:student), issue.student
          assert_equal assigns(:issues), issue.student.issues.sorted.select {|r| @abil.can? :read, r }
        end

      end

    end # roles loop

    (role_names - allowed_roles).each do |r|
      describe "restricted role: #{r}" do
        before do
          load_session(r)
        end

        test "redirected" do
          get :index
          assert_redirected_to "/access_denied"
        end
      end # describe
    end # role loops

  end # outer describe

  test "should get index" do
    #test for fetching index
    allowed_roles.each do |r|
      load_session(r)
      student = FactoryGirl.create :student

      get :index, {:student_id => student.AltID}
      assert_response :success
      assert_equal assigns(:student), student
      assert_equal assigns(:issues), student.issues.sorted.select {|r| can? :read, r }
    end
  end


  #TESTS FOR UNAUTHORIZED USERS

  test "should get not get index bad role" do
    #test for fetching index
    (role_names - allowed_roles).each do |r|
      load_session(r)
      student = FactoryGirl.create :student

      get :index, {:student_id => student.AltID}
      assert_redirected_to "/access_denied"
    end
  end

  test "should be allowed to destory issues" do
    (allowed_roles).each do |r|
      load_session(r)
          issue = FactoryGirl.create(:issue)
          delete :destroy, {:id => issue.id}
          assert_not assigns(:issue).visible
          assert_equal flash[:notice], "Deleted Successfully!"
          assert_redirected_to(student_issues_path(issue.student.id)) # makes sure the user has been redirected to the index page of the student issue page
    end
  end

  #test for unauthorized users

  test "should NOT be allowed to destroy issues" do
    issue = FactoryGirl.create(:issue)
    (role_names - allowed_roles).each do |r|
      load_session(r)
        post :destroy, {:id => issue.id}
        assert_redirected_to "/access_denied"
    end
  end

end

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
#

require 'test_helper'
require 'application_controller'
class IssuesControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "advisor"]

  test "should get new" do
    allowed_roles.each do |r|
      load_session(r)
      issue = Issue.new
      student = Student.first
      get :new, :student_id => student.AltID
      assert_response :success
      assert assigns(:issue).new_record?
      assert_equal assigns(:student), student
    end
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

      end

    end # allowed roles

  end

  # test "should post create" do
  #
  #   allowed_roles.each do |r|
  #     load_session(r)
  #
  #     stu = Student.first
  #     advisor = User.find_by(:UserName => session[:user]).tep_advisor
  #
  #     create_params ={
  #       :Name => "Test name",
  #       :Description => "Test descrip"
  #     }
  #
  #     expected_params = {
  #       :student_id => stu.id,
  #       :Name => create_params[:Name],
  #       :Description => create_params[:Description],
  #       :positive => false
  #       }
  #
  #
  #     post :create, {:student_id => stu.AltID, :issue => create_params}
  #
  #     #we expect that the two records will be the same except for id
  #     expected_issue = Issue.new(expected_params)
  #     actual_issue = assigns(:issue).attributes
  #     actual_attrs = expected_params.select { |k, v| expected_params.include?(k)}
  #
  #     assert_equal expected_params, actual_attrs
  #
  #     assert assigns(:issue).Open == !expected_params[:positive]
  #     assert assigns(:issue).present?, assigns(:issue) == nil
  #     assert assigns(:issue).valid?, assigns(:issue).errors.full_messages
  #
  #     assert_equal flash[:notice], "New issue opened for: #{ApplicationController.helpers.name_details(stu)}"
  #     assert_redirected_to student_issues_path(stu.AltID)
  #   end
  # end

  # test "should not post create bad record" do
  #   #should not succeed in saving a new record due to bad params
  #   load_session("admin")
  #
  #   student = Student.first
  #   advisor = TepAdvisor.first
  #
  #   create_params ={
  #     :Name => nil,   #breaking the record here.
  #     :Description => "Test descrip"
  #   }
  #
  #   expected_issue = Issue.create({
  #     :student_id => student.Bnum,
  #     :Name => create_params[:Name],
  #     :Description => create_params[:Description],
  #     :Open => true,
  #     :tep_advisors_AdvisorBnum => advisor.AdvisorBnum
  #     })
  #
  #   post :create, {:student_id => student.AltID, :issue => create_params}
  #
  #   #we expect that the two records will be the same except for id
  #   assert_response :success
  #   assert_template 'new'
  #
  # end

  test "should get index" do
    #test for fetching index
    allowed_roles.each do |r|
      load_session(r)
      student = Student.first

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
      student = Student.first

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

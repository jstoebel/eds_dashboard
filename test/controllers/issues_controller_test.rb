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
      py_assert assigns(:student), student
    end
  end

  test "should post create" do

    allowed_roles.each do |r|
      load_session(r)

      student = Student.first
      advisor = TepAdvisor.first

      create_params ={
        :Name => "Test name",
        :Description => "Test descrip"
      }

      expected_issue = Issue.create({
        :CreateDate => Date.today,
        :students_Bnum => student.Bnum,
        :Name => create_params[:Name],
        :Description => create_params[:Description],
        :Open => true,
        :tep_advisors_AdvisorBnum => advisor.AdvisorBnum
        })

      post :create, {:student_id => student.AltID, :issue => create_params}

      #we expect that the two records will be the same except for id
      expected_attr = expected_issue.attributes.delete(:id)
      actual_attr = assigns(:issue).attributes.delete(:id)
      
      py_assert expected_attr, actual_attr

      assert assigns(:issue).present?, assigns(:issue) == nil
      assert assigns(:issue).valid?, assigns(:issue).errors.full_messages

      py_assert flash[:notice], "New issue opened for: #{ApplicationController.helpers.name_details(student)}"
      assert_redirected_to student_issues_path(student.AltID)
    end
  end

  test "should not post create bad record" do
    #should not succeed in saving a new record due to bad params
    load_session("admin")

    student = Student.first
    advisor = TepAdvisor.first

    create_params ={
      :Name => nil,   #breaking the record here.
      :Description => "Test descrip"
    }

    expected_issue = Issue.create({
      :CreateDate => Date.today,
      :students_Bnum => student.Bnum,
      :Name => create_params[:Name],
      :Description => create_params[:Description],
      :Open => true,
      :tep_advisors_AdvisorBnum => advisor.AdvisorBnum
      })

    post :create, {:student_id => student.AltID, :issue => create_params}

    #we expect that the two records will be the same except for id
    assert_response :success
    assert_template 'new'

  end

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

  test "should get show" do
    allowed_roles.each do |r|
      load_session(r)
      issue = Issue.first
      get :show, {:id => issue.id}
      assert_response :success
      assert_equal issue, assigns(:issue)
      assert_equal assigns(:student), Student.find(issue.students_Bnum)

    end
  end

  test "should get resolve_issue" do
    allowed_roles.each do |r|
      load_session(r)
      iss = Issue.first
      
      get :resolve_issue, {:issue_id => iss.id}

      assert_equal iss, assigns(:issue)
      assert_equal iss.student, assigns(:student)

    end
  end

  test "should post close_issue" do
    allowed_roles.each do |r|
      load_session(r)
      user = User.find(session[:user])
      iss = Issue.first
      iss.Open = false
      stu = iss.student
      close_params = {
        :Description => "close it!"
      }

      expected_update = IssueUpdate.new({
          :Description => close_params[:Description], 
          :UpdateName => "Issue Resolved",
          :Issues_IssueID => iss.id,
          :tep_advisors_AdvisorBnum => user.tep_advisor.AdvisorBnum
        })

      post :close_issue, {:issue_id => iss.id, :issue_update => close_params}

      assert_equal iss, assigns(:issue)
      assert_equal stu, assigns(:student)

      #expected update and created update should have same attributes
      assert_equal expected_update.attributes.delete(:id), assigns(:update).attributes.delete(:id)
      assert_equal flash[:notice], "Issue resolved!"
      assert_redirected_to student_issues_path(stu.AltID)
      
    end
  end

  #TESTS FOR UNAUTHORIZED USERS

  #new does not pass through cancancan

  test "should not post create bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)

      student = Student.first
      create_params ={
        :Name => "Test name",
        :Description => "Test descrip"
      }
      post :create, {:student_id => student.AltID, :issue => create_params}
      assert_redirected_to "/access_denied"
    end
  end

  test "should get not get index bad role" do
    #test for fetching index
    (role_names - allowed_roles).each do |r|
      load_session(r)
      student = Student.first

      get :index, {:student_id => student.AltID}
      assert_redirected_to "/access_denied"
    end
  end

  test "should not get show bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      issue = Issue.first
      get :show, {:id => issue.id}
      assert_redirected_to "/access_denied"

    end
  end

  test "should not get resolve_issue bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      iss = Issue.first
      get :resolve_issue, {:issue_id => iss.id}
      assert_redirected_to "/access_denied"
    end
  end

test "should not post close_issue bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      user = User.find(session[:user])
      iss = Issue.first
      iss.Open = false
      stu = iss.student
      close_params = {
        :Description => "close it!"
      }

      expected_update = IssueUpdate.new({
          :Description => close_params[:Description], 
          :UpdateName => "Issue Resolved",
          :Issues_IssueID => "who cares",
          :tep_advisors_AdvisorBnum => "doesn't matter"
        })

      post :close_issue, {:issue_id => iss.id, :issue_update => close_params}
      assert_redirected_to "/access_denied"
      
    end
  end


end

require 'test_helper'

class IssueUpdatesControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "advisor"]

  test "should get new" do
    allowed_roles.each do |r|
      load_session(r)

      issue = Issue.first  #add an update to this issue

      get :new, {:issue_id => issue.id}
      assert_response :success
      assert_equal issue, assigns(:issue)
      assert_equal issue.student, assigns(:student)

      #was a new update created?
      assert assigns(:update).new_record?
      assert_not assigns(:update).changed?

    end
  end

  test "should post create" do
    allowed_roles.each do |r|
      load_session(r)
      issue = Issue.first
      user = User.find(session[:user])
      expected_update = IssueUpdate.create({
          :UpdateName => "Update!",
          :Description => "descrip!",
          :Issues_IssueID => issue.id,
          :tep_advisors_AdvisorBnum => user.tep_advisor.AdvisorBnum
        })


      create_params = {
        :UpdateName => expected_update.UpdateName,
        :Description => expected_update.Description
      }

      post :create, {:issue_id => issue.id, :issue_updates => create_params}
      assert_equal issue, assigns(:issue)
      assert_equal expected_update.attributes.delete(:UpdateID), assigns(:update).attributes.delete(:UpdateID)
      assert_equal issue.student, assigns(:student)
      assert_equal flash[:notice], "New update added"
      assert_redirected_to issue_issue_updates_path(issue.IssueID)
    end
  end

  test "should not post create bad record" do
    load_session("admin")
    issue = Issue.first
    user = User.find(session[:user])
    expected_update = IssueUpdate.create({
        :UpdateName => nil, #break the record here
        :Description => "descrip!",
        :Issues_IssueID => issue.id,
        :tep_advisors_AdvisorBnum => user.tep_advisor.AdvisorBnum
      })


    create_params = {
      :UpdateName => expected_update.UpdateName,
      :Description => expected_update.Description
    }

    post :create, {:issue_id => issue.id, :issue_updates => create_params}
    assert_response :success
    assert_template 'new'

  end

  test "should get index" do
    allowed_roles.each do |r|
      load_session(r)
      issue = Issue.first
      stu = issue.student

      get :index, {:issue_id => issue.id}

      assert_response :success
      assert_equal issue, assigns(:issue)
      assert_equal stu, assigns(:student)
      assert_equal issue.issue_updates.sorted, assigns(:updates)
    end
  end

  test "should get show" do
    allowed_roles.each do |r|
      load_session(r)
      update = IssueUpdate.first

      get :show, {:id => update.id}
      assert_response :success
      assert_equal update.issue, assigns(:issue)
      assert_equal update.issue.student, assigns(:student)
    end
  end
  
  #TESTS FOR UNAUTHORIZED USERS

end

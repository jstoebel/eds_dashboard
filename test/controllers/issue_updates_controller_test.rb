# == Schema Information
#
# Table name: issue_updates
#
#  UpdateID                 :integer          not null, primary key
#  UpdateName               :text             not null
#  Description              :text             not null
#  Issues_IssueID           :integer          not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#

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
      user = User.find_by(:UserName => session[:user])
      expected_update = IssueUpdate.create({
          :UpdateName => "Update!",
          :Description => "descrip!",
          :Issues_IssueID => issue.id,
          :tep_advisors_AdvisorBnum => user.tep_advisor.AdvisorBnum
        })


      create_params = {
        :UpdateName => expected_update.UpdateName,
        :Description => expected_update.Description,
        :issue => {:status => "Open"}
      }

      post :create, {:issue_id => issue.id, :issue_updates => create_params}
      assert_equal issue, assigns(:issue)
      expected_attrs = expected_update.attributes
      actual_attrs = assigns(:update).attributes


      #remove some attrs
      to_exclude = ["UpdateID", "created_at", "updated_at"]

      expected_attrs.except!(*to_exclude)
      actual_attrs.except!(*to_exclude)

      assert_equal expected_attrs, actual_attrs
      
      assert_equal issue.student, assigns(:student)
      assert_redirected_to issue_issue_updates_path(issue.IssueID)
      assert_equal flash[:notice], "New update added"
    end
  end

  test "should not post create bad record" do
    load_session("admin")
    issue = Issue.first
    user = User.find_by(:UserName => session[:user])
    expected_update = IssueUpdate.create({
        :UpdateName => nil, #break the record here
        :Description => "descrip!",
        :Issues_IssueID => issue.id,
        :tep_advisors_AdvisorBnum => user.tep_advisor.AdvisorBnum
      })


    create_params = {
      :UpdateName => expected_update.UpdateName,
      :Description => expected_update.Description,
        :issue => {:Open => true}
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
  test "should not get new bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :new, {:issue_id => "who cares"}
      assert_redirected_to "/access_denied"
    end
  end

  test "should not post create bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      create_params = {
        :UpdateName => "who cares",
        :Description => "blah blah blah"
      }

      post :create, {:issue_id => "meh", :issue_updates => create_params}
      assert_redirected_to "/access_denied"
    end
  end

  test "should not get index bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :index, {:issue_id => "who cares"}
      assert_redirected_to "/access_denied"
    end
  end

  test "should not get show bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :show, {:id => "spam"}
      assert_redirected_to "/access_denied"
    end
  end

end

# == Schema Information
#
# Table name: assessment_versions
#
#  id            :integer          not null, primary key
#  assessment_id :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class AssessmentVersionsControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "staff"]
  
  def assert_form_setup
    assert_equal assigns(:assessments), Assessment.all
    assert_equal assigns(:items), AssessmentItem.all
  end
  
  test "should get index for versions of same assessment" do
    assess = FactoryGirl.create :assessment
    allowed_roles.each do |r|
      load_session(r)
      get :index, params: {assessment_id: assess.id}
      assert_response :success
      assert_equal assigns(:version), AssessmentVersion.where(:assessment_id => assess.id)
    end
  end
  
  test "should get index" do
    allowed_roles.each do |r|
      load_session(r)
      get :index
      assert_response :success
      assert_equal assigns(:version), AssessmentVersion.all
    end
  end
  
  test "should get new" do
    allowed_roles.each do |r|
      load_session(r)
      assess = FactoryGirl.create(:assessment)
      #version = AssessmentVersion.new
      get :new, :assessment_id => assess.id
      assert_response :success
      assert assigns(:version).new_record?
      assert_equal assigns(:assessment), assess
    end
  end

  test "should post create" do
    allowed_roles.each do |r|
      load_session(r)
      assess = FactoryGirl.create(:assessment)
      version = AssessmentVersion.new
      create_params = {:assessment_version => {:assessment_id => assess.id}}
      post :create, create_params
      #assert_response :success
      assessment_params = create_params[:assessment_version]
      expected_assessment = AssessmentVersion.new assessment_params
      assert assigns(:version).valid?, assigns(:version).inspect
      assert_redirected_to assessment_assessment_versions_path(:assessment_id)
    end
  end 
  
  test "should get delete" do
    allowed_roles.each do |r|
      load_session(r)
      version = FactoryGirl.create :assessment_version
      get :delete, assessment_version_id: version.id
      assert_response :success
      assert_equal assigns(:version), version
    end
  end
  
  test "should delete" do
    allowed_roles.each do |r|
      load_session(r)
      version = FactoryGirl.create :assessment_version
      post :destroy, id: version.id
      assert_equal version, assigns(:version)
      assert assigns(:version).destroyed?
      assert_redirected_to assessment_assessment_versions_path(assigns(:version).assessment_id)
      assert_equal flash[:notice], "Record deleted successfully"
    end
  end
  
   test "should get edit" do
    allowed_roles.each do |r|
      load_session(r)
      version = FactoryGirl.create :assessment_version
      get :edit, :id => version.id
      assert_response :success
      assert_form_setup
      assert_equal assigns(:version), version
    end
  end

=begin  test "should post update" do
##still unsure about updating, since can only update assessment_items
    allowed_roles.each do |r|
      load_session(r)
      version = FactoryGirl.create :assessment_version
      item = FactoryGirl.create :assessment_item
      version.assessment_items.id = item
      #edit_params = {:assessment_items => AssessmentItem.find(item.id)}}
      post :update, {:id => version.id, :assessment_version => edit_params}
      assert_redirected_to(assessment_versions_path)
      assert_equal flash[:notice], "Updated Version #{version.version_num} of #{Assessment.find(version.assessment_id).name}"
      assert_equal assigns(:version), version
    end
=end
  
  ##Bad roles
  
  test "should not get index bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :index
      assert_equal flash[:notice], "You are not authorized to access this page."
      assert_redirected_to "/access_denied"
    end
  end
  
  test "should not get new bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :new
      assert_equal flash[:notice], "You are not authorized to access this page."
      assert_redirected_to "/access_denied"
    end
  end
  
  test "should not post create bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      post :create
      assert_equal flash[:notice], "You are not authorized to access this page."
      assert_redirected_to "/access_denied"
    end
  end
  
=begin 
##still unsure about updating, since can only update assessment_items
  test "should not post update, bad role" do
    version = FactoryGirl.create :assessment_version
    update_params = {: => "updated name", :description => "updated description"}
    (role_names - allowed_roles).each do |r|
      load_session(r)
      post :update, {:id => version.id, :assessment => update_params}
      assert_redirected_to "/access_denied"
    end
=end
  
  test "should not get delete bad role" do
    version = FactoryGirl.create :assessment_version
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :delete, {:assessment_version_id => version.id}
      assert_equal flash[:notice], "You are not authorized to access this page."
      assert_redirected_to "/access_denied"
    end
  end

  test "should not delete bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      version = FactoryGirl.create :assessment_version
      post :destroy, {:id => version.id}
      assert_equal flash[:notice], "You are not authorized to access this page."
      assert_redirected_to "/access_denied"
    end
  end
  
  #Bad params
  
  test "should not delete has scores" do
    allowed_roles.each do |r|
      load_session(r)
      version = FactoryGirl.create :version_with_items
      stu_score = FactoryGirl.create :student_score, {:assessment_version_id => version.id}
      post :destroy, {:id => version.id}
      assert assigns(:version).present?
      assert_equal flash[:notice], "Record cannot be deleted"
      assert_redirected_to(assessment_assessment_versions_path(version.assessment_id))
    end
  end
  
  test "should not post create, no assessment" do 
    allowed_roles.each do |r|
      load_session(r)
      create_params = {:assessment_id => nil}
      post :create, {:assessment_version => create_params}
      assert_not assigns(:version).valid?
      assert_response(200)    #assert on the same page
    end
  end
end

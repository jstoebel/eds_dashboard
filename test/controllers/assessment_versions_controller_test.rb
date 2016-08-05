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
  
  # def assert_form_setup
  #   assert_equal assigns(:assessments), Assessment.all
  #   assert_equal assigns(:items), AssessmentItem.all
  # end
  
  test "should get index for versions of same assessment" do
    assess = FactoryGirl.create :assessment
    allowed_roles.each do |r|
      load_session(r)
      get :index, params: {assessment_id: assess.id}
      assert_equal assigns(:version), AssessmentVersion.where(:assessment_id => assess.id)
      assert_response :ok
      assert_equal @response.body, assigns(:version).to_json
    end
  end
  
  test "should get index" do
    allowed_roles.each do |r|
      load_session(r)
      version = AssessmentVersion.all
      get :index
      assert_equal @response.body, assigns(:version).to_json
      assert_equal assigns(:version), AssessmentVersion.all
      assert_response :ok
    end
  end
  
  test "should get show" do
    allowed_roles.each do |r|
      load_session(r)
      ver = FactoryGirl.create(:assessment_version)
      get :show, :id => ver.id
      assert_equal assigns(:version), ver
      assert_equal @response.body, assigns(:version).to_json
      assert_response :ok
    end
  end

  test "should post create" do
    allowed_roles.each do |r|
      load_session(r)
      assess = FactoryGirl.create(:assessment)
      create_params = {:assessment_id => assess.id}
      post :create, {:assessment_version => create_params}
      assert_equal assess, assigns(:version).assessment
      assert assigns(:version).valid?
      create_params.each_key{|attri| assert_equal create_params[attri], assigns(:version).attributes["#{attri}"]}
      assert_equal @response.body, assigns(:version).to_json
      assert_response :created
    end
  end
  
  test "should post destroy" do
    allowed_roles.each do |r|
      load_session(r)
      version = FactoryGirl.create :assessment_version
      post :destroy, id: version.id
      assert_equal version, assigns(:version)
      assert assigns(:version).destroyed?
      assert_response :no_content
    end
  end

  test "should post update" do
    allowed_roles.each do |r|
      load_session(r)
      version = FactoryGirl.create :assessment_version
      new_assess = FactoryGirl.create :assessment
      update_params = {:assessment_id => new_assess.id}
      post :update, {:id => version.id, :assessment_version => update_params}
      assert_equal assigns(:version), version
      update_params.each_key{|attri| assert_equal update_params[attri], assigns(:version).attributes["#{attri}"]}
      assert_equal @response.body, assigns(:version).to_json
      assert_response :ok
    end
  end
  
  ##Bad roles
  
  test "should not get index bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :index
      assert_redirected_to "/access_denied"
    end
  end
  
  test "should not get show bad role" do
    version = FactoryGirl.create :assessment_version
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :show, :id => version.id
      assert_redirected_to "/access_denied"
    end
  end
  
  test "should not post create bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      post :create
      assert_redirected_to "/access_denied"
    end
  end

  test "should not post update, bad role" do
    version = FactoryGirl.create :assessment_version
    new_assess = FactoryGirl.create :assessment
    update_params = {:assessment_id => new_assess.id}
    (role_names - allowed_roles).each do |r|
      load_session(r)
      post :update, {:id => version.id, :assessment_version => update_params}
      assert_redirected_to "/access_denied"
    end
  end
  
  test "should not destroy bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      version = FactoryGirl.create :assessment_version
      post :destroy, {:id => version.id}
      assert_redirected_to "/access_denied"
    end
  end
  
  #Bad params
  
  test "should not destroy has scores" do
    allowed_roles.each do |r|
      load_session(r)
      version = FactoryGirl.create :version_with_items
      stu_score = FactoryGirl.create :student_score, {:assessment_version_id => version.id}
      post :destroy, {:id => version.id}
      assert_not assigns(:version).destroyed?
      assert_equal @response.body, assigns(:version).errors.full_messages.to_json
      assert_response :unprocessable_entity
    end
  end
  
  test "should not post update, no assessment" do
    allowed_roles.each do |r|
      load_session(r)
      version = FactoryGirl.create :assessment_version
      update_params = {:assessment_id => nil}
      post :update, {:id => version.id, :assessment_version => update_params}
      assert_equal assigns(:version), version
      assert_not assigns(:version).valid?
      assert_equal @response.body, assigns(:version).errors.full_messages.to_json
      assert_response :unprocessable_entity
    end
  end
  
  test "should not post create, no assessment" do 
    allowed_roles.each do |r|
      load_session(r)
      create_params = {:assessment_id => nil}
      post :create, {:assessment_version => create_params}
      assert_equal @response.body, assigns(:version).errors.full_messages.to_json
      assert_response :unprocessable_entity
    end
  end
end
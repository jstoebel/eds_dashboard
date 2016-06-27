require 'test_helper'
require 'factory_girl'
require 'application_controller'
require 'test_teardown'

class AssessmentsControllerTest < ActionController::TestCase

  allowed_roles = ["admin", "staff", "staff", "student labor"]
  
  test "should get index" do
    allowed_roles.each do |r|
      load_session(r)
      assess = Assessment.all
      get :index
      assert_response :success
      assert_equal assigns(:assessment), assess
    end
  end
  
  test "should get new" do
    allowed_roles.each do |r|
      load_session(r)
      get :new
      assert_response :success
      assert assigns(:assessment).new_record?
    end
  end
  
  test "should post create" do
    #How does this test whether saved?
    allowed_roles.each do |r|
      load_session(r)
      create_params = {:name => "test name", :description => "test descrip"}
      post :create, {:assessment => create_params}
      assert assigns(:assessment).valid?
      assert_redirected_to(assessments_path)
      assert_equal flash[:notice], "Created Assessment #{assigns(:assessment).name}."
    end
  end
  
  test "should get edit" do
    allowed_roles.each do |r|
      load_session(r)
      assess = FactoryGirl.create :assessment
      get :edit, id: assess.id 
      assert_response :success
      assert_equal assess, assigns(:assessment)
    end
  end

  test "should post update" do
    allowed_roles.each do |r|
      load_session(r)
      assess = FactoryGirl.create :assessment
      assess.name = "updated name!"
      update_params = {:name => assess.name}
      post :update, {:id => assess.id, :assessment => update_params}
      assert assigns(:assessment).valid?    #was assessment saved?
      assert_equal assess, assigns(:assessment)
      assert_redirected_to(assessments_path)
      assert_equal flash[:notice], "Updated Assessment #{assigns(:assessment).name}."
    end
  end

  test "should get delete" do
    allowed_roles.each do |r|
      load_session(r)
      assess = FactoryGirl.create :assessment
      get :delete, assessment_id: assess.id
      assert_response :success
      assert_equal assess, assigns(:assessment)
    end
  end
  
  test "should destroy assessment and versions" do 
    allowed_roles.each do |r|
      load_session(r)
      assess = FactoryGirl.create :assessment
      version = FactoryGirl.create :assessment_version, {
        :assessment_id => assess.id
      }    #version of assessment to test dependent deleting

      post :destroy, {:id => assess.id}
      assert_equal assess, assigns(:assessment)
      assert_not assigns(:assessment).has_scores == true
      assert assigns(:assessment).destroyed?
      assigns(:assessment).assessment_versions.each{|i| assert i.destroyed?}
      assert_equal flash[:notice], "Record deleted successfully"
      assert_redirected_to(assessments_path)
    end
  end
  
  #Not do, invalid object/didn't save

  test "should not post create, invalid object" do
    allowed_roles.each do |r|
      load_session(r)
      create_params = {:name => nil, :description => "test descrip"}
      post :create, {:assessment => create_params}
      assert_not assigns(:assessment).valid?
      assert_response(200)    #assert on the same page
    end
  end
  
  test "should not post update, not saved" do
    allowed_roles.each do |r|
      load_session(r)
      assess = FactoryGirl.create :assessment
      assess.name = nil
      update_params = {:name => assess.name}
      post :update, {:id => assess.id, :assessment => update_params}
      assert_equal assigns(:assessment), assess
      assert_not assigns(:assessment).valid?
      assert_response :success    #stayed on same page, rendering edit
      assert_template 'edit'
    end
  end
  
  test "should not destroy, has scores" do
    allowed_roles.each do |r|  ##TODO must create assesment version and scores here too
      load_session(r)
      assess = FactoryGirl.create :assessment
      version = FactoryGirl.create :assessment_version, {
        :assessment_id => assess.id
      }
      score = FactoryGirl.create :student_score, {
        :assessment_version_id => version.id
      }
      
      post :destroy, {:id => assess.id}
      assert_equal assess, assigns(:assessment)
      assert assigns(:assessment).has_scores == true
      assert_not assigns(:assessment).destroyed?
      assigns(:assessment).assessment_versions.each{
        |i| assert_not i.destroyed?
      }
      assigns(:assessment).assessment_versions.each{
        |i| i.student_scores.each{
          |j| assert_not j.destroyed?
        }
      }
      assert_equal flash[:notice], "Record cannot be deleted"
      assert_redirected_to(assessments_path)
    end
  end
  
  ##Unauthorized users
  test "should not get index, bad role" do    #I think this fails because I don't know the actual allowed roles
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :index
      assert_redirected_to "/access_denied"
    end
  end

  test "should not post create, bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      create_params = {:name => "test name", :description => "test descrip"}
      post :create, {:assessment => create_params}
      assert_redirected_to "/access_denied"
    end
  end
  
  test "should not get new, bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :new
      assert_redirected_to "/access_denied"
    end
  end

  test "should not get edit, bad role" do
    assess = FactoryGirl.create :assessment
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :edit, id: assess.id
      assert_redirected_to "/access_denied"
    end
  end
  
  test "should not post update, bad role" do
    assess = FactoryGirl.create :assessment
    update_params = {:name => "updated name", :description => "updated description"}
    (role_names - allowed_roles).each do |r|
      load_session(r)
      post :update, {:id => assess.id, :assessment => update_params}
      assert_redirected_to "/access_denied"
    end
  end
  
  test "should not get delete, bad role" do
    assess = FactoryGirl.create :assessment
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :delete, assessment_id: assess.id
      assert_redirected_to "/access_denied"
    end
  end
  
  test "should not post destroy, bad role" do
    assess = FactoryGirl.create :assessment
    (role_names - allowed_roles).each do |r|
      load_session(r)
      post :destroy, {:id => assess.id}
      assert_redirected_to "/access_denied"
      assert assess.valid?    #asserts not deleted
    end
  end
end

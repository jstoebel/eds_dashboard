# == Schema Information
#
# Table name: version_habtm_items
#
#  id                    :integer          not null, primary key
#  assessment_version_id :integer          not null
#  assessment_item_id    :integer          not null
#  created_at            :datetime
#  updated_at            :datetime
#

require 'test_teardown'
require 'test_helper'

class VersionHabtmItemsControllerTest < ActionController::TestCase
  include TestTeardown
  allowed_roles = ["admin", "staff"]
  
  test "should post create" do
    allowed_roles.each do |r|
      load_session(r)
      ver = FactoryGirl.create :assessment_version
      item = FactoryGirl.create :assessment_item
      create_filler = {:assessment_version_id => ver.id, :assessment_item_id => item.id}
      post :create, {:version_habtm_items => create_filler}
      assert assigns(:item_ver).valid?
      assert_equal @response.body, assigns(:item_ver).to_json
      assert_response :created
    end
  end
  
  test "Should destroy" do
    allowed_roles.each do |r|
      load_session(r)
      item_ver = FactoryGirl.create(:version_habtm_item)
      post :destroy, :id => item_ver.id
      assert_equal item_ver, assigns(:item_ver)
      assert assigns(:item_ver).destroyed?
      assert_response :no_content
    end
  end
  
  #Bad roles
  test "should not post create, bad role" do
    ver = FactoryGirl.create :assessment_version
    item = FactoryGirl.create :assessment_item
    create_filler = {:assessment_version_id => ver.id, :assessment_item_id => item.id}
    (role_names - allowed_roles).each do |r|
      load_session(r)
      post :create, {:version_habtm_items => create_filler}
      assert_redirected_to "/access_denied"
    end
  end
  
  test "should not post destory, bad role" do
    item_ver = FactoryGirl.create(:version_habtm_item)
    (role_names - allowed_roles).each do |r|
      load_session(r)
      post :destroy, {:id => item_ver.id}
      assert_redirected_to "/access_denied"
    end
  end
  
  #Fail, bad params
  test "Should not post create, no assessment_version_id" do
    item = FactoryGirl.create :assessment_item
    allowed_roles.each do |r|
      load_session(r)
      create_param_filler = {
        :assessment_version_id => nil,
        :assessment_item_id => item.id
      }
      post :create, {:version_habtm_items => create_param_filler}
      assert_not assigns(:item_ver).valid?
      assert_equal @response.body, assigns(:item_ver).errors.full_messages.to_json
      assert_response :unprocessable_entity 
    end
  end
  
  test "Should not destroy, has scores" do
    ver = FactoryGirl.create :version_with_items    #has scores
    item_ver = VersionHabtmItem.find_by(assessment_version_id: ver.id)
    allowed_roles.each do |r|
      load_session(r)
      post :destroy, :id => item_ver.id
      assert_equal item_ver, assigns(:item_ver)
      assert_not assigns(:item_ver).destroyed?
      assert_equal @response.body, assigns(:item_ver).errors.full_messages.to_json
      assert_response :unprocessable_entity
    end
  end
end
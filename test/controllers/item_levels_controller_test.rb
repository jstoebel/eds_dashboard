# == Schema Information
#
# Table name: item_levels
#
#  id                 :integer          not null, primary key
#  assessment_item_id :integer          not null
#  descriptor         :text(65535)
#  level              :string(255)
#  ord                :integer
#  created_at         :datetime
#  updated_at         :datetime
#  cut_score          :boolean
#

require 'test_helper'
require 'test_teardown'

class ItemLevelsControllerTest < ActionController::TestCase
  include TestTeardown
  allowed_roles = ["admin", "staff"]
    
  test "should get index" do
    allowed_roles.each do |r|
      load_session(r)
      ver = FactoryGirl.create :version_with_items
      item = ver.assessment_items.first
      get :index, {:assessment_version_id => ver.id, :assessment_item_id => item.id}
      assert_equal assigns(:item), item
      assert_equal assigns(:level), item.item_levels.sorted
      assert_equal @response.body, assigns(:level).to_json
      assert_response :ok
    end
  end
  
  test "should get show" do
    allowed_roles.each do |r|
      load_session(r)
      level = FactoryGirl.create :item_level
      get :show, :id => level.id
      assert_equal level, assigns(:level)
      assert_equal @response.body, assigns(:level).to_json
      assert_response :ok
    end
  end
  
  test "should post create" do
    allowed_roles.each do |r|
      load_session(r)
      item = FactoryGirl.create :assessment_item
      create_param_filler = {:assessment_item_id => "#{item.id}",
        :descriptor => "This Description",
        :level => "good",
        :ord => "1"
      }
      post :create, {:item_level => create_param_filler}
      assert assigns(:level).valid?
      assert_equal @response.body, assigns(:level).to_json
      assert_response :created
    end
  end
  
  test "Should patch update" do
    allowed_roles.each do |r|
      load_session(r)
      level = FactoryGirl.create :item_level
      update_params = {:assessment_item_id => "#{level.assessment_item.id}", :descriptor => "test update descriptor", :level => "test update lvl", :ord => "2"}
      patch :update, {:id => level.id, :item_level => update_params}
      assert assigns(:level).valid?
      assert_equal level, assigns(:level)
      assert_equal @response.body, assigns(:level).to_json
      assert_response :ok
    end
  end
      
  test "should post destroy" do
    allowed_roles.each do |r|
      load_session(r)
      level = FactoryGirl.create :item_level
      post :destroy, {:id => level.id}
      assert_equal level, assigns(:level)
      assert assigns(:level).destroyed?
      assert_response :no_content
    end
  end
  
  #Bad Roles
  test "Should not get index, bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      ver = FactoryGirl.create :version_with_items
      item = ver.assessment_items.first
      get :index, {:assessment_version_id => ver.id, :assessment_item_id => item.id}
      assert_redirected_to "/access_denied"
    end
  end
    
  test "should not get show, bad role" do
    level = FactoryGirl.create :item_level
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :show, :id => level.id
      assert_redirected_to "/access_denied"
    end
  end
  
  test "Should not post create, bad role" do
    item = FactoryGirl.create :assessment_item
    (role_names - allowed_roles).each do |r|
      load_session(r)
      create_param_filler = {:assessment_item_id => "#{item.id}",
        :descriptor => "This Description",
        :level => "good",
        :ord => "1"
      }
      post :create, {:item_level => create_param_filler}
      assert_redirected_to "/access_denied"
    end
  end
  
   test "Should not patch update, bad role" do
    level = FactoryGirl.create :item_level
    (role_names - allowed_roles).each do |r|
      load_session(r)
      update_params = {:assessment_item_id => "#{level.assessment_item.id}", :descriptor => "test update descriptor", :level => "test not update lvl", :ord => "2"}
      patch :update, {:id => level.id, :item_level => update_params}
      assert_redirected_to "/access_denied"
    end
  end
      
  test "should not post destroy, bad role" do
    level = FactoryGirl.create :item_level
    (role_names - allowed_roles).each do |r|
      load_session(r)
      post :destroy, {:id => level.id}
      assert_redirected_to "/access_denied"
    end
  end
  
  #Has scores
    test "Should not post create, item has scores" do
    allowed_roles.each do |r|
      load_session(r)
      ver = FactoryGirl.create :version_with_items
      item = ver.assessment_items.first    #this item has scores
      create_param_filler = {:assessment_item_id => "#{item.id}",
        :descriptor => "This Description",
        :level => "test create level",
        :ord => "2"
      }
      post :create, {:item_level => create_param_filler}
      assert_not assigns(:level).valid?
      assert_equal @response.body, assigns(:level).errors.full_messages.to_json
      assert_response :unprocessable_entity
    end
  end
  
   test "Should not patch update, has scores" do
    allowed_roles.each do |r|
      load_session(r)
      item = FactoryGirl.create(:version_with_items).assessment_items.first
      level = item.item_levels.first
      update_params = {:assessment_item_id => "#{level.assessment_item.id}", :descriptor => "test update descriptor", :level => "test not update lvl", :ord => "2"}
      patch :update, {:id => level.id, :item_level => update_params}
      assert_not assigns(:level).valid?
      assert_equal @response.body, assigns(:level).errors.full_messages.to_json
      assert_response :unprocessable_entity
    end
  end
      
  test "should not post destroy, item has scores" do
    allowed_roles.each do |r|
      load_session(r)
      item = FactoryGirl.create(:version_with_items).assessment_items.first
      level = item.item_levels.first
      post :destroy, :id => level.id
      assert_equal level, assigns(:level)
      assert_not assigns(:level).destroyed?
      assert_equal @response.body, assigns(:level).errors.full_messages.to_json
      assert_response :unprocessable_entity
    end
  end
end

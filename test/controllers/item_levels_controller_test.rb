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
  
  test "should create new Item Level" do
    allowed_roles.each do |r|
      load_session(r)
      create_param_filler = {:assessment_item_id => "21",
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
      #create associated version since update checks that the versions have no scores
      # to ensure that the item can be modified
      ver = FactoryGirl.create(:assessment_version)
      ver.save!
      level.assessment_item.assessment_versions << ver
      update_params = {:assessment_item_id => "2", :descriptor => "test update descriptor", :level => "test update lvl", :ord => "2"}
      patch :update, {:id => level.id, :item_level => update_params}
      assert assigns(:level).valid?
      assert_equal level, assigns(:level)
      assert_equal @response.body, assigns(:level).to_json
      assert_response :ok
    end
  end
      
  test "should post destroy level" do
    allowed_roles.each do |r|
      load_session(r)
        level = FactoryGirl.create :item_level
        level.assessment_item = FactoryGirl.create(:assessment_item)
        post :destroy, {:id => level.id}
        assert_equal level, assigns(:level)
        assert assigns(:level).destroyed?
        assert_response :no_content
    end
  end
  
  #Bad Roles
    
  test "should not create new due to role" do
    
  end

  #Bad Params/Can't save
  
end

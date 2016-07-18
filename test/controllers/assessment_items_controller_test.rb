require 'test_helper'
require 'test_teardown'

class AssessmentItemsControllerTest < ActionController::TestCase
    include TestTeardown
    allowed_roles = ["admin", "staff"]
    
    test "should get create" do
        allowed_roles.each do |r|
            load_session(r)
            
        end
    end
    
    test "Update - Old levels deleted if not similar, new levels added" do
      allowed_roles.each do |r|
        load_session(r)
        update_params = {:assessment_item => {:slug => "NewSlug", :description => "New description", :name => "New Name", 
        :item_level_attributes => [{:descriptor => "descriptor", :level => "Word String", :ord => 3}]}}
        item = FactoryGirl.create :assessment_item
        old_lvl = FactoryGirl.create :item_level, {:assessment_item_id => item.id}
        patch :update, update_params
        assert_response :success
        assert_equal assigns(:item), item
        assert_equal assigns(:item.item_levels.attributes), update_params[:assessment_item][:item_level_attributes]
        @response.body
      end
    end
end
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
    
    test "Update - delete old levels, no scores" do
      allowed_roles.each do |r|
        load_session(r)
        item = FactoryGirl.create :assessment_item
        old_lvl = FactoryGirl.create :item_level, {:assessment_item_id => item.id}
        
        update_params = {
            "assessment_item" => {
                "id" => "#{item.id}",
                "slug"=> "NewSlug",
                "description" => "New description", 
                "name" => "New Name",
                "item_levels_attributes" => [{
                    "descriptor" => "descriptor", 
                    "level" => "Word String", 
                    "ord" => "3"}]
            }
        }
        patch :update, update_params #{format: :json}
        assert_response :success
        assert_equal assigns(:item), item
        assert_equal @response.body, assigns(:item).to_json
        
        new_lvls = ItemLevel.where(:assessment_item_id => assigns(:item).id)
        lvls_attributes = []
        new_lvls.map do |i|
            lvl = {}
            lvl["descriptor"] = i["descriptor"]
            lvl["level"] = i["level"]
            lvl["ord"] = i["ord"].to_s  #must be string to compare with json
            lvls_attributes.push(lvl)
        end
        #assert new created
        assert_equal lvls_attributes, update_params["assessment_item"]["item_levels_attributes"]
        #assert old destroyed
        assert assigns(:old_levels).destroyed?
      end
    end
end
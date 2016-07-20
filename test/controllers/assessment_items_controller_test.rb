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
        puts item.item_levels.inspect
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
        
        
        #assert old_lvl.destroyed?
        puts update_params[:assessment_item].inspect
        assert_equal assigns(:item).item_levels.map{|i| i.attributes}, update_params[:assessment_item][:item_level_attributes]
        #assert new created
        #puts "here are the attributes"
        #attri = 
        #puts attri.inspect
        #assert_equal assigns(:item).item_levels.map{|k| k.attributes}, 
        assert_equal @response.body, assigns(:item).to_json
      end
    end
end
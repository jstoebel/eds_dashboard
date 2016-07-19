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
        item = FactoryGirl.create :assessment_item
        old_lvl = FactoryGirl.create :item_level, {:assessment_item_id => item.id}
        
        update_params = {
            "assessment_item" => {
                "id" => "#{item.id}",
                "slug"=> "NewSlug", 
                "description" => "New description", 
                "name" => "New Name", 
                "item_levels" => [{
                    "descriptor" => "descriptor", 
                    "level" => "Word String", 
                    "ord" => "3"}]
            }
        }

        patch :update, {format: :json, :assessment_item => update_params}
        assert_response :success
        assert_equal assigns(:item), item
        assert_equal assigns(:item.item_levels.attributes), update_params[:assessment_item][:item_level_attributes]
        assert_equal @response.body, assigns(:item).to_json
      end
    end
    
=begin    private
    def raw_post(action, params, body)
      @request.env['RAW_POST_DATA'] = body
      response = patch(action, params)
      @request.env.delete('RAW_POST_DATA')
      response
=end
end
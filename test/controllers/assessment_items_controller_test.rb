require 'test_helper'
require 'test_teardown'

class AssessmentItemsControllerTest < ActionController::TestCase
    include TestTeardown
    allowed_roles = ["admin", "staff"]
    
    test "Should get index" do
        version = FactoryGirl.create :version_with_items
        allowed_roles.each do |r|
            load_session(r)
            get :index, :assessment_version_id => version.id
            assert_equal assigns(:item), version.assessment_items.sorted
            assert_equal @response.body, assigns(:item).to_json
            assert_response :success
        end
    end
    
    test "Should get show" do 
        allowed_roles.each do |r|
            load_session(r)
            item = FactoryGirl.create :assessment_item
            get :show, :id => item.id
            assert_equal item, assigns(:item)
            assert_equal @response.body, assigns(:item).to_json
            assert_response :success
        end
    end
    
    test "Should patch update" do
    
    end
    
    test "Should not get index, bad role" do
    end
    
    test "Should not get show, bad role" do 
    end
    
    test "Should not patch update, bad role" do 
    end
    
    test "Should not get index, bad params" do
    end
    
    test "Should not get show, bad params" do 
    end
        
    test "Should not patch update, bad params" do 
    end

end
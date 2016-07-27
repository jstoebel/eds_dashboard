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
            assert_response :ok
        end
    end
    
    test "Should get show" do 
        allowed_roles.each do |r|
            load_session(r)
            item = FactoryGirl.create :assessment_item
            get :show, :id => item.id
            assert_equal item, assigns(:item)
            assert_equal @response.body, assigns(:item).to_json
            assert_response :ok
        end
    end
    
    test "Should post create" do
        allowed_roles.each do |r|
            load_session(r)
            create_params = {:slug => "test slug", :description => "test description", :name => "test name"} 
            post :create, {:assessment_item => create_params}
            assert assigns(:item).valid?
            assert_response :created    
        end
    end
    
    test "Should patch update" do
        allowed_roles.each do |r|
            load_session(r)
            item = FactoryGirl.create :assessment_item
            update_params = {:id => item.id , :slug => "test slug", :description => "test description", :name => "test name"}
            patch :update, {:assessment_item => update_params}
            assert assigns(:item).valid?
            assert_equal item, assigns(:item)
            assert_response :ok
        end
    end
    
    test "Should delete item" do
        allowed_roles.each do |r|
            load_session(r)
            item = FactoryGirl.create :assessment_item
            post :destroy, {:id => item.id}
            assert_equal item, assigns(:item)
            assert assigns(:item).destroyed?
            assert_response :no_content
        end
    end
    
    test "Should delete item and associated levels" do
        ##item.item_levels.inspect gives empty Collection, but level.assessment_item_id == item.id
        allowed_roles.each do |r|
            load_session(r)
            level = FactoryGirl.create :item_level
            item = level.assessment_item
            post :destroy, {:id => item.id}
            assert_equal item, assigns(:item)
            assert_equal item.item_levels, assigns(:item).item_levels
            assert assigns(:item).destroyed?
            assert assigns(:item).item_levels.each{ |l| l.destroyed? }
            assert_response :no_content
        end
    end
    
    ##Bad params
    test "Should not patch update, has scores" do
    end
    
        
    test "Should not get index, bad params" do
    end
    
    test "Should not get show, bad params" do 
    end
        
    test "Should not patch update, bad params" do 
    end
    
    
    ###Bad Roles
    test "Should not get index, bad role" do
    end
    
    test "Should not get show, bad role" do 
    end
    
    test "Should not patch update, bad role" do 
    end


end
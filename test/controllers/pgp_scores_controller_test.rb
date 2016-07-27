require 'test_helper'

class PgpScoresControllerTest < ActionController::TestCase
    
    allowed_roles = ["admin", "staff"] 
    
    test "should get index" do
        allowed_roles.each do |r|
            load_session(r)
        pgp = FactoryGirl.create :pgp
        score = FactoryGirl.create :pgp_score
        get :index, {:pgp_id => pgp.id}
        assert_response :success
        end
    end
    
    test "Should not get index - bad role" do 
        (roles - allowed_roles).each do |r|
        pgp = FactoryGirl.create :pgp
        score = FactoryGirl.create :pgp_score
        
        get :index, {:pgp_id => pgp.id}
        
        end
    end
    
    test "should create pgp_score" do 
        allowed_roles.each do |r|
            load_session(r)
        pgp = FactoryGirl.create :pgp
        create_pgp_score = {:pgp_score => {:pgp_id => pgp.id,
        :goal_score => 2,
        :score_reason => "Test Reason"}
        }
        post :create, create_pgp_score
        assert assigns(:pgp_score).valid?
        assert_equal flash[:notice], "Scored professional growth plan."
        assert_redirected_to pgp_pgp_scores_path(assigns(:pgp_score).pgp_id)
        end
    end
end
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
            create_pgp_score = {:pgp_id => pgp.id, :goal_score => 2, :score_reason => "Test Reason"}
            post :create, {:pgp_id => pgp.id, :pgp_score => create_pgp_score}
            assert assigns(:pgp_score).valid?
            assert_equal flash[:notice], "Scored professional growth plan."
            assert_redirected_to pgp_pgp_scores_path(assigns(:pgp_score).pgp_id)
        end
    end
    
    test "should not create pgp_score - bad role" do 
        (roles - allowed_roles).each do |r|
            load_session(r)
            pgp = FactoryGirl.create :pgp
            pgp_score = FactoryGirl.create :pgp_score
            post :create, {:pgp_id => pgp.id}
            assert_equal flash[:notice], "Error scoring professional growth plan."
        end
    end
    
    test "should update pgp_score" do 
        pgp = FactoryGirl.create :pgp
        allowed_roles.each do |r|
            load_session(r)
            score = FactoryGirl.create :pgp_score, {:pgp_id => pgp.id, :goal_score => 1, :score_reason => "nil"}
            expected_attr = {:goal_score => 3, :score_reason => "Test reason"}
            post :update, {:id => score.id, :pgp_score => expected_attr}
            assert_equal(assigns(:pgp_score), score)
            assert_redirected_to pgp_pgp_scores_path(assigns(:pgp_score).pgp_id)
        end
    end
    
    test "should not update pgp_score - bad role" do 
        pgp = FactoryGirl.create :pgp
        (roles - allowed_roles).each do 
            load_session(r)
            score = FactoryGirl.create :pgp_score, {:pgp_id => pgp.id, :goal_score => 1, :score_reason => "nil"}
            expected_attr = {:goal_score => 3, :score_reason => "Test reason"}
            post :update, {:id => score.id, :pgp_score => expected_attr}
            assert_equal flash[:notice], "Error in updating PGP score."
        end
    end
    
    test "should delete pgp score" do 
        allowed_roles.each do |r|
            load_session(r)
            pgp = FactoryGirl.create :pgp
            score = FactoryGirl.create :pgp_score
            post :destroy, {:id => score.id}
            assert_equal(assigns(:pgp_score), score)
            assert_equal flash[:notice], "Deleted Successfully"
            assert_redirected_to pgp_pgp_scores_path(assigns(:pgp_score).pgp_id)
        end
    end
    
    test "should not delete pgp_Score - bad role" do
        (roles - allowed_roles).each do |r|
            load_session(r)
            pgp = FactoryGirl.create :pgp
            score = FactoryGirl.create :pgp_score
            post :destroy, {:id => score.id}
            assert_equal flash[:notice], "Error in Deleting PGP Score"
            assert_redirected_to pgp_pgp_scores_path(assigns(:pgp_score).pgp_id)
        end
    end
    
    
end
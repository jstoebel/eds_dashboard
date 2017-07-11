# == Schema Information
#
# Table name: pgp_scores
#
#  id           :integer          not null, primary key
#  pgp_id       :integer
#  goal_score   :integer
#  score_reason :text(65535)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class PgpScoresControllerTest < ActionController::TestCase

    allowed_roles = ["admin", "staff"]

    test "should get index" do
        allowed_roles.each do |r|
            load_session(r)
            pgp = FactoryGirl.create :pgp
            get :index, params: {:pgp_id => pgp.id}
            assert_response :success
            expected_pgp_score = PgpScore.all
            assert_equal assigns(:pgp_scores).to_a, expected_pgp_score.to_a
        end
    end

    test "Should not get index - bad role" do
        (roles - allowed_roles).each do |r|
        pgp = FactoryGirl.create :pgp
        score = FactoryGirl.create :pgp_score

        get :index, params: {:pgp_id => pgp.id}
        assert_redirected_to "/access_denied"
        end
    end

    test "should create pgp_score" do
        allowed_roles.each do |r|
            load_session(r)
            pgp = FactoryGirl.create :pgp
            create_pgp_score = {:pgp_id => pgp.id, :goal_score => 2, :score_reason => "Test Reason"}
            post :create, params: {:pgp_id => pgp.id, :pgp_score => create_pgp_score}
            assert assigns(:pgp_score).valid?
            assert_equal flash[:info], "Scored professional growth plan."
            assert_redirected_to pgp_pgp_scores_path(assigns(:pgp_score).pgp_id)
        end
    end

    test "should not create pgp_score - bad params" do
        allowed_roles.each do |r|
            load_session(r)
            pgp = FactoryGirl.create :pgp
            create_pgp_score = {:pgp_id => pgp.id, :goal_score => 2}
            post :create, params: {:pgp_id => pgp.id, :pgp_score => create_pgp_score}
            assert_not assigns(:pgp_score).valid?
            assert_equal flash[:info], "Error creating professional growth plan."
            assert_equal pgp, assigns(:pgp)
            assert_equal pgp.student, assigns(:student)
            assert_template 'new'
        end
    end

    test "should not create pgp_score - bad role" do
        (roles - allowed_roles).each do |r|
            load_session(r)
            pgp = FactoryGirl.create :pgp
            pgp_score = FactoryGirl.create :pgp_score
            post :create, params: {:pgp_id => pgp.id}
            assert_redirected_to "/access_denied"
        end
    end

    test "should update pgp_score" do
        pgp = FactoryGirl.create :pgp
        allowed_roles.each do |r|
            load_session(r)
            score = FactoryGirl.create :pgp_score, {:pgp_id => pgp.id, :goal_score => 1, :score_reason => "nil"}
            expected_attr = {"goal_score" => 3, "score_reason" => "Test reason"}
            post :update, params: {:id => score.id, :pgp_score => expected_attr}

            all_attrs = assigns(:pgp_score).attributes
            actual_attrs = all_attrs.select{ |k,v| expected_attr.include?(k)}

            assert_equal actual_attrs, expected_attr
            assert_equal(assigns(:pgp_score), score)
            assert_equal flash[:info], "PGP score successfully updated"
            assert_redirected_to pgp_pgp_scores_path(assigns(:pgp_score).pgp_id)
        end
    end

    test "should not update pgp_score - bad params" do
        pgp = FactoryGirl.create :pgp
        allowed_roles.each do |r|
            load_session(r)
            score = FactoryGirl.create :pgp_score, {:pgp_id => pgp.id, :goal_score => 1, :score_reason => "reason goes here"}
            expected_attr = {"goal_score" => 3, "score_reason" => nil}
            post :update, params: {:id => score.id, :pgp_score => expected_attr}

            assert_equal score, assigns(:pgp_score)
            assert_equal score.pgp, assigns(:pgp)

            assert_equal "Error in updating PGP score.", flash[:info]
            assert :success
            assert_equal score.pgp.student, assigns(:student)
            assert_template "edit"
        end
    end


    test "should not update pgp_score - bad role" do
        pgp = FactoryGirl.create :pgp
        (roles - allowed_roles).each do
            load_session(r)
            score = FactoryGirl.create :pgp_score, {:pgp_id => pgp.id, :goal_score => 1, :score_reason => "nil"}
            expected_attr = {:goal_score => 3, :score_reason => "Test reason"}
            post :update, params: {:id => score.id, :pgp_score => expected_attr}
            assert_redirected_to "access_denied/"
        end
    end

    test "should delete pgp score" do
        allowed_roles.each do |r|
            load_session(r)
            pgp = FactoryGirl.create :pgp
            score = FactoryGirl.create :pgp_score
            post :destroy, params: {:id => score.id}
            assert_equal(assigns(:pgp_score), score)
            assert_equal flash[:info], "Deleted Successfully"
            assert_redirected_to pgp_pgp_scores_path(assigns(:pgp_score).pgp_id)
        end
    end

    test "should not delete pgp_Score - bad role" do
        (roles - allowed_roles).each do |r|
            load_session(r)
            pgp = FactoryGirl.create :pgp
            score = FactoryGirl.create :pgp_score
            post :destroy, params: {:id => score.id}
            assert_redirected_to "access_denied/"
        end
    end
    
end

require 'test_helper'

class PgpScoreTest < ActiveSupport::TestCase
    
    test "score is greater than zero validation" do 
       score = PgpScore.new
       score.goal_score = 0
       score.valid?
       assert_equal([], score.errors[:pgp_id])
    end
    
    test "score is less than five" do 
        score = PgpScore.new
        score.goal_score = 5
        score.valid?
        assert_equal([], score.errors[:pgp_id])
    end
    
    test "validation for score reason" do 
        score = PgpScore.new
        score.score_reason = ""
        score.valid?
        assert_equal(["Please enter a score reason."], score.errors[:pgp_id])
    end
    
end
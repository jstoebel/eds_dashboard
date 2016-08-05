require 'test_helper'

class PgpScoreTest < ActiveSupport::TestCase
    
    test "score is zero validation" do 
       score = PgpScore.new({:goal_score => 0})
       assert_not score.valid?, score.errors.full_messages
       assert_equal(["must be greater than 0"], score.errors[:goal_score])
     
    end
    
    test "score is five" do 
        score = PgpScore.new({:goal_score => 5})
        assert_not score.valid?, score.errors.full_messages
        assert_equal(["must be less than 5"], score.errors[:goal_score])
    end
    
    test "validation for score reason" do 
        score = PgpScore.new({:score_reason => ""})
        assert_not score.valid?, score.errors.full_messages
        assert_equal(["Please enter a score reason."], score.errors[:score_reason])
    end
    
end
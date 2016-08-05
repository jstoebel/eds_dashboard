
require 'test_helper'

class PgpTest < ActiveSupport::TestCase
  
  test "needs student id" do
    pgp = Pgp.new
    pgp.student_id = nil
		pgp.valid?
		assert_equal(["There must be an active student associated."], pgp.errors[:student_id])
	end
	
	test "needs goal name" do
	  pgp = Pgp.new
    pgp.goal_name = nil
		pgp.valid?
		assert_equal(["Please enter a goal."], pgp.errors[:goal_name])
  end
  
  test "needs description" do
	  pgp = Pgp.new
    pgp.description = nil
		pgp.valid?
		assert_equal(["Please enter a description."], pgp.errors[:description])
	end
  
  test "needs a plan" do
  	pgp = Pgp.new
    pgp.plan = nil
		pgp.valid?
		assert_equal(["Please enter a plan."], pgp.errors[:plan])
  end
  
  test "score check pass" do
    pgp = Pgp.new
    pgp.destroy
    assert_same(pgp.destroyed?, true)
    
  end
  
  test "can't update because a score exists" do
    score = FactoryGirl.create :pgp_score  
    assert_not score.pgp.destroy
  end
  
  test "is the latest score correct" do
    num_scores = 3
    score = FactoryGirl.create_list(:pgp_score, num_scores)
    ordered_score = score.sort_by{ |a| [a.pgp_id, a.created_at]}
    sort_ver = PgpScore.sorted
    assert_equal ordered_score, sort_ver
  end 
  
end

require 'test_helper'

class PgpTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  #test "should have required validators" do
    #end
  #end
  test "needs student id" do
    pgp = Pgp.new
    pgp.student_id = nil
		pgp.valid?
		assert_equal(["There must be an active student associated."], pgp.errors[:student_id])
	end
	
	test "needs goal name" do
	  pgp = Pgp.new
    pgp.goal_name = nil
		pgp.valid?
		assert_equal(["Please enter a goal."], pgp.errors[:goal_name])
  end
  
  test "needs description" do
	  pgp = Pgp.new
    pgp.description = nil
		pgp.valid?
		assert_equal(["Please enter a description."], pgp.errors[:description])
	end
  
  test "needs a plan" do
  	pgp = Pgp.new
    pgp.plan = nil
		pgp.valid?
		assert_equal(["Please enter a plan."], pgp.errors[:plan])
  end
  
  test "score check pass" do
    pgp = Pgp.new
    pgp.destroy
    assert_same(pgp.destroyed?, true)
    
  end
  
  test "can't update because a score exists" do
    score = FactoryGirl.create :pgp_score  #before we can have pgp_score, we need a pgp and a student  student(root, has many pgps) => pgp(has many pgp_scores) => pgp_score
    assert_not score.pgp.destroy
  end
  
  test "is the latest score correct" do
    num_scores = 3
    score = FactoryGirl.create_list(:pgp_score, num_scores)
    sleep(2)
    score.unshift(FactoryGirl.create(:pgp_score))
    ordered_score = score.sort_by{ |a| [a.pgp_id, a.created_at]}
    sort_ver = PgpScore.sorted
    assert_equal ordered_score, sort_ver
  end 
  
end

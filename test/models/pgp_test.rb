
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
    pgp = pgp.new
    pgp.pgp_scores = nil
    pgp.destroy
    assert_same(pgp.destroyed?, true)
    
  end
  
  test "score check fail" do
    
  end
  
  test "latest score is correct" do
  
  end
  
end

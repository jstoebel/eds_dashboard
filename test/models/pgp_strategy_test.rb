# == Schema Information
#
# Table name: pgp_strategies
#
#  id          :integer          not null, primary key
#  pgp_goal_id :integer
#  name        :string(255)
#  timeline    :text(65535)
#  resources   :text(65535)
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

##
# tests for pgp_strategy model
class PgpStrategyTest < ActiveSupport::TestCase
  describe 'required fields' do
    before do
      @strategy = PgpStrategy.new
      @strategy.valid?
    end
    %i[pgp_goal_id name timeline resources].each do |attr|
     
      test attr do
        assert @strategy.errors[attr].include? 'can\'t be blank'
      end # test
    end # attrs loop
    test 'active' do
      assert @strategy.errors[:active].include? 'must be true or false'
    end
  end # required fields

  ##
  # should get the correct student
  test 'student' do
    goal = FactoryGirl.create :pgp_goal
    strat = FactoryGirl.create :pgp_strategy, pgp_goal: goal
    assert_equal goal.student, strat.student
  end

  describe 'allows three' do
    before do
      @goal = FactoryGirl.create :pgp_goal
    end
    test 'allows three others when new' do
      FactoryGirl.create_list :pgp_strategy, 3, pgp_goal: @goal, active: true
      error = assert_raises(ActiveRecord::RecordInvalid) do
        FactoryGirl.create :pgp_strategy, pgp_goal: @goal, active: true
      end
      assert_equal error.message, 'Validation failed: Goal may only have ' \
                                         'three active strategies at any given time.'
    end

    test 'allows two others when not new' do
      FactoryGirl.create_list :pgp_strategy, 3, pgp_goal: @goal, active: true

      # starts out belonging to another goal
      new_strat = FactoryGirl.create :pgp_strategy, active: true
      new_strat.pgp_goal_id = @goal.id

      error = assert_raises(ActiveRecord::RecordInvalid) do
        new_strat.save!
      end
      assert_equal error.message, 'Validation failed: Goal may only have ' \
                                         'three active strategies at any given time.'
    end
  end
end

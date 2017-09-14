# == Schema Information
#
# Table name: pgp_goals
#
#  id         :integer          not null, primary key
#  student_id :integer
#  name       :string(255)
#  domain     :string(255)
#  active     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class PgpGoalTest < ActiveSupport::TestCase
  describe 'required fields' do
    before do
      @pgp_goal = PgpGoal.new
      @pgp_goal.valid?
    end
    [:student_id, :name, :domain].each do |attr|
      
      test attr do
        assert @pgp_goal.errors[attr].include? 'can\'t be blank'
      end # test
    end # attrs loop
    test 'active' do
      assert @pgp_goal.errors[:active].include? 'must be true or false'
    end
  end # required fields

  test 'valid Danielson name' do
    goal = FactoryGirl.build :pgp_goal, domain: 'bad domain name'
    goal.valid?
    assert goal.errors[:domain].include? 'Please select a valid Danielson domain'
  end

  describe 'allows three' do
    before do
      @stu = FactoryGirl.create :student
    end
    test 'allows three others when new' do

      FactoryGirl.create_list :pgp_goal, 3, student: @stu, active: true
      error = assert_raises(ActiveRecord::RecordInvalid) do
        FactoryGirl.create :pgp_goal, student: @stu, active: true
      end
      assert_equal error.message, 'Validation failed: Student may only have three active ' \
                                         'PGP goals at any given time.'
    end

    test 'allows two others when not new' do
      FactoryGirl.create_list :pgp_goal, 3, student: @stu, active: true
      goal = FactoryGirl.create :pgp_goal, active: true # starts out belonging to another student
      goal.student_id = @stu.id

      error = assert_raises(ActiveRecord::RecordInvalid) do
        goal.save!
      end

      assert_equal error.message, 'Validation failed: Student may only have three active ' \
                                  'PGP goals at any given time.'
    end

  end
end

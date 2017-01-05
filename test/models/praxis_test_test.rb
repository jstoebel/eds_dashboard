# == Schema Information
#
# Table name: praxis_tests
#
#  id               :integer          not null, primary key
#  TestCode         :string(45)       not null
#  TestName         :string(255)
#  CutScore         :integer
#  TestFamily       :string(1)
#  Sub1             :string(255)
#  Sub2             :string(255)
#  Sub3             :string(255)
#  Sub4             :string(255)
#  Sub5             :string(255)
#  Sub6             :string(255)
#  Sub7             :string(255)
#  Program_ProgCode :integer
#  CurrentTest      :boolean
#

require 'test_helper'

class PraxisTestTest < ActiveSupport::TestCase

	test "scope current" do
		current_tests = FactoryGirl.create_list :praxis_test, 2, {:CurrentTest => true}
		FactoryGirl.create_list :praxis_test, 2, {:CurrentTest => false}
		expected = PraxisTest.current
		assert_equal(expected.to_a.sort, current_tests.sort)
	end


end

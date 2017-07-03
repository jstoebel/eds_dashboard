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
	end # scope current
  
	describe "family_roman" do
		
		test "with a value" do
			pt = FactoryGirl.create :praxis_test, :TestFamily => 1
			assert_equal 'I', pt.family_roman
		end # with a value
		
		test "with no value" do
			pt = FactoryGirl.create :praxis_test, :TestFamily => nil
			assert_nil pt.family_roman
		end # with no value
	
	end # describe family_roman
	
	describe "family_readable" do
		
		test "with a value" do
			pt = FactoryGirl.create :praxis_test, :TestFamily => 1
			assert_equal 'Praxis I', pt.family_readable
		end # with a value
		
		test "with no value" do
			pt = FactoryGirl.create :praxis_test, :TestFamily => nil
			assert_nil pt.family_readable
		end # with no value
		
	end # describe family_readable


end

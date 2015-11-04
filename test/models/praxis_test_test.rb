require 'test_helper'

class PraxisTestTest < ActiveSupport::TestCase

	test "scope current" do
		expected = PraxisTest.current.to_a
		actual = PraxisTest.where("CurrentTest=1").to_a
		py_assert(expected, actual)
	end

	
end

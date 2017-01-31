require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

	test "name details standard name" do
		s = FactoryGirl.create :student, {:FirstName => "first",
			:PreferredFirst => nil,
			:LastName => "last",
			:PrevLast => nil
		}
		assert_equal name_details(s), "first last"
		assert_equal name_details(s, file_as = true), "last, first"
	end

	test "name details with prev last name" do
		s = FactoryGirl.create :student, {:FirstName => "first",
			:PreferredFirst => nil,
			:LastName => "last",
			:PrevLast => "prevLast"
		}
		assert_equal name_details(s), "first last (prevLast)"
		assert_equal name_details(s, file_as = true), "last (prevLast), first"
	end

	test "name details with pref first name" do
		s = FactoryGirl.create :student, {:FirstName => "first",
			:PreferredFirst => "preffirst",
			:LastName => "last",
			:PrevLast => nil
		}
		assert_equal name_details(s), "preffirst (first) last"
		assert_equal name_details(s, file_as = true), "last, preffirst (first)"
	end

	test "current term default params" do
		term = FactoryGirl.create :banner_term, {:StartDate => 10.days.ago,
			:EndDate => 10.days.from_now}

		assert_equal term, current_term
	end

	test "current term not exact go forward" do
		term = FactoryGirl.create :banner_term, {:StartDate => 1.day.from_now,
			:EndDate => 2.days.from_now}
		assert_equal term, current_term(exact: false)
	end

	test "current term not exact go back" do
		term = FactoryGirl.create :banner_term, {:StartDate => 2.days.ago,
			:EndDate => 1.day.ago}
		assert_equal term, current_term(:exact => false, :plan_b => :back)
	end

	test "current term date not today" do
		term = FactoryGirl.create :banner_term, {:StartDate => 3.days.ago,
			:EndDate => 1.day.ago}
		assert_equal term, current_term(:date => 2.days.ago)
	end

end

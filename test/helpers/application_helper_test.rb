require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

	test "name details standard name" do
		s = Student.first
		s.FirstName = "first"
		s.PreferredFirst = nil
		s.LastName = "last"
		s.PrevLast = nil
		assert s.valid?
		assert_equal name_details(s), "first last"
		assert_equal name_details(s, file_as = true), "last, first"
	end

	test "name details with prev last name" do
		s = Student.first
		s.FirstName = "first"
		s.PreferredFirst = nil
		s.LastName = "last"
		s.PrevLast = "prevlast"
		assert s.valid?
		assert_equal name_details(s), "first last (prevlast)"
		assert_equal name_details(s, file_as = true), "last (prevlast), first"
	end

	test "name details with pref first name" do
		s = Student.first
		s.FirstName = "first"
		s.PreferredFirst = 'preffirst'
		s.LastName = "last"
		s.PrevLast = nil
		assert s.valid?
		assert_equal name_details(s), "preffirst (first) last"
		assert_equal name_details(s, file_as = true), "last, preffirst (first)"
	end

	test "current term default params" do
		travel_to Date.new(2015, 10, 1) do	#oct 1st 2015
			term = current_term
			assert_equal term, BannerTerm.find(201511)
		end
	end

	test "current term not exact" do
		travel_to Date.new(2015, 7, 4) do	#between 201514 and 201511
			term = current_term exact: false
			assert_equal term, BannerTerm.find(201511)
		end		
	end

	test "current term not exact go back" do
		travel_to Date.new(2015, 7, 4) do	#between 201514 and 201511
			term = current_term exact: false, plan_b: :back
			assert_equal term, BannerTerm.find(201415)
		end		
	end

	test "current term date not today" do
		term = current_term exact: false, plan_b: :back, date: Date.new(2015, 10, 1)
		assert_equal term, BannerTerm.find(201511)
	end

end

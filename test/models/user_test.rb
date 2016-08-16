# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  UserName      :string(45)       not null
#  FirstName     :string(45)       not null
#  LastName      :string(45)       not null
#  Email         :string(45)       not null
#  Roles_idRoles :integer          not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase

	test "check admin pass" do
		#admin with no view_as
		user = User.where(:Roles_idRoles => 1).first		#role 1 is admin
		assert user.is? "admin"
	end

	test "check admin fail" do
		#admin with no view_as
		user = User.where(:Roles_idRoles => 1).first		#role 1 is admin
		assert_not user.is? "staff"
	end

	test "check admin as staff pass" do
		#admin with no view_as
		user = User.where(:Roles_idRoles => 1).first		#role 1 is admin
		user.view_as = 3
		assert user.is? "staff"
	end

	test "check admin as staff fail" do
		#admin with no view_as
		user = User.where(:Roles_idRoles => 1).first		#role 1 is admin
		user.view_as = 3
		assert_not user.is?"admin"
	end

	test "validates presence of Email" do
		u = User.new
		assert_not u.valid?
		assert_equal u.errors[:Email], ["can't be blank"]
	end

	

end

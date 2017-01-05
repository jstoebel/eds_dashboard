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

	describe "admin" do
		before do
			@user = FactoryGirl.create :admin
		end
		test "check admin pass" do
			assert @user.is? "admin"
		end
		test "check admin fail" do
			assert_not @user.is? "staff"
		end

		(2..4).each do |role_num|
			test "acting as role #{role_num}" do
				@user.view_as = role_num
				role = Role.find_by :idRoles => role_num
				assert @user.send("is?", role.RoleName)
			end
		end
	end

	test "check admin staff pass" do
		@user = FactoryGirl.create :staff
		assert @user.is? "staff"
	end


	test "validates presence of Email" do
		u = User.new
		assert_not u.valid?
		assert_equal u.errors[:Email], ["can't be blank"]
	end

	["admin", "staff"].each do |role|
		test "#{role}_emails" do
			FactoryGirl.create role.to_sym
			role_record = Role.find_by :RoleName => role
			assert_equal User.where({:Roles_idRoles => role_record.id}).pluck(:Email).to_a, User.send("#{role}_emails")
		end
	end

end

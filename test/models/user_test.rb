require 'test_helper'

class UserTest < ActiveSupport::TestCase

	test "check admin as admin" do
		user = User.where(:Roles_idRoles => 1).first		#role 1 is admin
		assert user.is? "admin"
	end

end

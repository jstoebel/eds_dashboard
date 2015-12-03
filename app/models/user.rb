class User < ActiveRecord::Base

	#associations
		belongs_to :role, foreign_key: "Roles_idRoles"

	#scopes

	def role_name
		return self.role.RoleName
	end	

  # User::Roles
  # The available roles
  Roles = [ :admin , :advisor, :staff, :stu_labor ]

  def is?(other)
  	return self.role_name == other.to_s
  end

end

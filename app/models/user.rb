class User < ActiveRecord::Base

	#associations
		belongs_to :role, foreign_key: "Roles_idRoles"
	#scopes
end

class Role < ActiveRecord::Base

	has_many :users, foreign_key: "Roles_idRoles"
end

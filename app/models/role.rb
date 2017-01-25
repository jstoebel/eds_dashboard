# == Schema Information
#
# Table name: roles
#
#  idRoles  :integer          not null, primary key
#  RoleName :string(45)       not null
#

class Role < ActiveRecord::Base

	has_many :users, foreign_key: "Roles_idRoles"
end

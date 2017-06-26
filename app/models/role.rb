# == Schema Information
#
# Table name: roles
#
#  idRoles  :integer          not null, primary key
#  RoleName :string(45)       not null
#

# a user role

class Role < ApplicationRecord

  has_many :users, foreign_key: "Roles_idRoles"
end

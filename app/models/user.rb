# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  UserName      :string(45)       not null
#  FirstName     :string(45)       not null
#  LastName      :string(45)       not null
#  Email         :string(100)      not null
#  Roles_idRoles :integer          not null
#

class User < ApplicationRecord

  attr_accessor :view_as

  #associations
  belongs_to :role, foreign_key: "Roles_idRoles"
  has_one :tep_advisor

  #validations
  validates_presence_of :Email

  def self.admin_emails
    # returns an array of emails of all users with admin role name
    return User.where({:Roles_idRoles => 1}).pluck(:Email)
  end

  def self.staff_emails
    # returns an array of emails of all users with staff role name
    return User.where({:Roles_idRoles => 3}).pluck(:Email)
  end
  #scopes

  def role_name
    # get the role name for this role
    return self.role.RoleName
  end

  # User::Roles
  # The available roles
  Roles = [ :admin , :advisor, :staff, :stu_labor ]

  def is?(other)
    # returns what role the user is currently representing.
    #if user is admin and they have a :view_as in their session hash, return that psudo role
    #pre:
      #other: role (string) we are comparing to
    #post:

    if self.role_name == 'admin' and self.view_as.present?
      #return the psudo role
      psudo_role = Role.find(self.view_as.to_i)
      return psudo_role.RoleName == other.to_s

    else
      return self.role_name == other.to_s

    end

  end



end

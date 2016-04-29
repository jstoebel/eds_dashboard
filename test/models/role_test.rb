# == Schema Information
#
# Table name: roles
#
#  idRoles  :integer          not null, primary key
#  RoleName :string(45)       not null
#
# Indexes
#
#  RoleName_UNIQUE  (RoleName) UNIQUE
#

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

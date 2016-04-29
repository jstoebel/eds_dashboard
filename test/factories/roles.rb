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

#NOPE!
#we aren't going to load this using factories. 
# It requires specific records which are defined in seeds.rb
# just run rake db:seed to load this up

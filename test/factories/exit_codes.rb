# == Schema Information
#
# Table name: exit_codes
#
#  id          :integer          not null, primary key
#  ExitCode    :string(5)        not null
#  ExitDiscrip :string(45)       not null
#

FactoryGirl.define do
  factory :exit_code do

    #need to be entered by the caller
  end 
end

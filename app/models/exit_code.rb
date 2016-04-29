# == Schema Information
#
# Table name: exit_codes
#
#  id          :integer          not null, primary key
#  ExitCode    :string(5)        not null
#  ExitDiscrip :string(45)       not null
#

class ExitCode < ActiveRecord::Base
	has_many :prog_exits, foreign_key: "ExitCode_ExitCode"
end

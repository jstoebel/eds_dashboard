# == Schema Information
#
# Table name: exit_codes
#
#  id          :integer          not null, primary key
#  ExitCode    :string(5)        not null
#  ExitDiscrip :string(45)       not null
#

# an EPSB program exit code
class ExitCode < ApplicationRecord
	has_many :prog_exits, foreign_key: "ExitCode_ExitCode"

	def repr
		return self.ExitDiscrip
	end
end

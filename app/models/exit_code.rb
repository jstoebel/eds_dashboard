class ExitCode < ActiveRecord::Base
	has_many :prog_exits, foreign_key: "ExitCode_ExitCode"
end
